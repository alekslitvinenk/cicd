const https = require('https');
const fs = require('fs');
const port = 3000;
const request = require('request');

const pathPrefix = process.argv.slice(2)[0];
const sslFilesDir = process.argv.slice(2)[1];

const options = {
  key: fs.readFileSync(`${sslFilesDir}/private.key`),
  cert: fs.readFileSync(`${sslFilesDir}/certificate.crt`)
};

const colorMap = {
  build: {
    passing: "green",
    failing: "red"
  },

  built: "lightgrey"
}

function getBadgeColor(badge, status) {
  const badgeColors = colorMap[badge];

  if (typeof badgeColors == "object") {
    return badgeColors[status];
  } else {
    return badgeColors + ""
  }
}

const server = https.createServer(options, (req, res) => {
  if (isBadgeUrl(req.url)) {

    const urlSegmenst = req.url.slice(1).split("/");
    const badge = urlSegmenst[0];
    const app = urlSegmenst[1];

    console.log(`Badge: ${badge}`);
    console.log(`App: ${app}`);

    fs.readFile(`${pathPrefix}/${badge}/${app}.txt`, (err, data) => {
      if (err) {
        console.log(`Err: ${err}`)
        render404(req, res)
      } else {
        // Dirty hack to convert "data" to string and sanitize it
        const status = (data + "").replace(/[\n\r]+/g, '');

        const x = request(`https://img.shields.io/badge/${badge}-${status}-${getBadgeColor(badge, status)}.svg`);
        req.pipe(x);
        x.pipe(res);
      }
    })
  } else {
    console.log(`isBadgeUrl: false`)
    render404(req, res)
  }
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});

function isBadgeUrl(url) {
  return url.slice(1).split("/").length == 2;
}

function render404(req, res) {
  res.statusCode = 404;
  res.setHeader('Content-Type', 'text/plain');
  res.end(`Requested url "${req.url}" not found!`);
}