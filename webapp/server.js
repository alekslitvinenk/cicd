const http = require('http');
const https = require('https');
const fs = require('fs');
const port = 3000;
const securePort = 3443;
const request = require('request');

const badgesDir = process.argv.slice(2)[0];
const sslFilesDir = process.argv.slice(2)[1];
const templatesDir = process.argv.slice(2)[2];
const reportsDir = process.argv.slice(2)[3];

const startHttpsServer = process.env.START_HTTPS_SERVER === "true";
const appInstallPath = process.env.APP_INSTALL_PATH;
const sslKeyFile = process.env.SSL_KEY_FILE;
const sslCertFile = process.env.SSL_CERT_FILE;
const sslChainFile = process.env.SSL_CHAIN_FILE;

const reportsPath = "reports"

const pug = require('pug');
const compiledFunction = pug.compileFile(`${templatesDir}/report-view.pug`);


const colorMap = {
  build: {
    passing: "green",
    failing: "red"
  },

  tests: {
    passing: "green",
    failing: "red"
  },

  built: "green",
  version: "blue"
};

const requestHandler = (req, res) => {

  if (isReportUrl(req.url)) {
    const urlSegments = req.url.slice(1).split("/");
    const app = urlSegments[1];

    console.log("Reports");
    console.log(`App: ${app}`);

    fs.readFile(`${reportsDir}/${app}.json`, (err, data) => {
      if (err) {
        console.log(`Err: ${err}`);
        render404(req, res);
      } else {
        // Dirty hack to convert "data" to string and sanitize it
        const jsonStr = (data + "").replace(/[\n\r]+/g, '');

        const renderedView = compiledFunction({jsonData: jsonStr, appName: app});

        res.statusCode = 200;
        res.setHeader('content-type', 'text/html');
        res.setHeader('cache-control', 'no-store');
        res.write(renderedView);
        res.end();
      }
    });
  } else if (isBadgeUrl(req.url)) {

    const urlSegments = req.url.slice(1).split("/");
    const badge = urlSegments[0];
    const app = urlSegments[1];

    console.log(`Badge: ${badge}`);
    console.log(`App: ${app}`);

    fs.readFile(`${badgesDir}/${badge}/${app}.txt`, (err, data) => {
      if (err) {
        console.log(`Err: ${err}`);
        render404(req, res);
      } else {
        // Dirty hack to convert "data" to string and sanitize it
        const status = (data + "").replace(/[\n\r]+/g, '');

        request(`https://img.shields.io/badge/${badge}-${status}-${getBadgeColor(badge, status)}.svg`, (error, response, body) => {
          res.statusCode = response.statusCode;
          res.setHeader('content-type', response.headers['content-type']);
          res.setHeader('cache-control', 'no-store');
          res.write(body);
          res.end();
        });
      }
    })
  } else if (req.url == "/health" ) {
    const buildDir = `${appInstallPath}/badges/build`
    fs.readdir(buildDir, (err, files) => {
      console.log(`Reading dir: ${buildDir}`);
      console.log(err);

      const statusOk = files.filter(fp => fp.endsWith(".txt"))
        .map(path => fs.readFileSync(`${buildDir}/${path}`) + "")
        .map(res => res.trimEnd())
        .every(res => res === "passing");
      
      res.statusCode = statusOk === true ? 200 : 503;
      res.setHeader('content-type', 'text/html');
      res.setHeader('cache-control', 'no-store');
      res.end(statusOk + "");
    });
  } else {
    console.log(`isBadgeUrl: false`);
    render404(req, res);
  }
};

function getBadgeColor(badge, status) {
  const badgeColors = colorMap[badge];

  if (typeof badgeColors == "object") {
    return badgeColors[status];
  } else {
    return badgeColors + ""
  }
}

function isReportUrl(url) {
  const segments = url.slice(1).split("/");

  return segments.length == 2 && segments[0] == reportsPath
}

function isBadgeUrl(url) {
  return url.slice(1).split("/").length === 2;
}

function render404(req, res) {
  res.statusCode = 404;
  res.setHeader('Content-Type', 'text/plain');
  res.end(`Requested url "${req.url}" not found!`);
}

http
  .createServer(requestHandler)
  .listen(port, () => {
      console.log(`Server running at http://localhost:${port}/`);
    }
  );

if (startHttpsServer) {
  const options = {
    key: fs.readFileSync(`${sslFilesDir}/${sslKeyFile}`),
    cert: fs.readFileSync(`${sslFilesDir}/${sslCertFile}`)
  };

  if (sslChainFile.length > 0) {
    options["chain"] = [fs.readFileSync(`${sslFilesDir}/${sslChainFile}`)]
  }

  https
    .createServer(options, requestHandler)
    .listen(securePort, () => {
        console.log(`Server running at https://localhost:${port}/`);
      }
    )
}