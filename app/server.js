const http = require('http');
const https = require('https');
const fs = require('fs');
const port = 3000;
const securePort = 3443;
const request = require('request');

const pathPrefix = process.argv.slice(2)[0];
const sslFilesDir = process.argv.slice(2)[1];

const colorMap = {
  build: {
    passing: "green",
    failing: "red"
  },

  built: "green",
  version: "blue"
};

const requestHandler = (req, res) => {
  if (isBadgeUrl(req.url)) {

    const urlSegments = req.url.slice(1).split("/");
    const badge = urlSegments[0];
    const app = urlSegments[1];

    console.log(`Badge: ${badge}`);
    console.log(`App: ${app}`);

    fs.readFile(`${pathPrefix}/${badge}/${app}.txt`, (err, data) => {
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


const options = {
  key: fs.readFileSync(`${sslFilesDir}/private.key`),
  cert: fs.readFileSync(`${sslFilesDir}/certificate.crt`)
};

https
  .createServer(options, requestHandler)
  .listen(securePort, () => {
      console.log(`Server running at http://localhost:${port}/`);
    }
  );