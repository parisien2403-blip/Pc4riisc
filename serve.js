const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8765;
const ROOT = __dirname;

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.webmanifest': 'application/manifest+json'
};

function requestHandler(req, res) {
  var urlPath = decodeURIComponent((req.url || '/').split('?')[0]);
  var filePath = path.join(ROOT, urlPath.replace(/^\//, '').replace(/\//g, path.sep));
  if (urlPath.endsWith('/') || !path.extname(filePath)) {
    filePath = path.join(filePath, 'index.html');
  }
  if (!filePath.startsWith(ROOT)) {
    res.writeHead(403);
    return res.end('Forbidden');
  }
  fs.readFile(filePath, function (err, data) {
    if (err) {
      res.writeHead(404);
      return res.end('Not found: ' + urlPath);
    }
    res.writeHead(200, { 'Content-Type': MIME[path.extname(filePath).toLowerCase()] || 'application/octet-stream' });
    res.end(data);
  });
}

http.createServer(requestHandler).listen(PORT, '127.0.0.1', function () {
  console.log('');
  console.log('  TRIGONE PC — serveur local');
  console.log('  http://localhost:' + PORT + '/');
  console.log('');
  console.log('  Installez l\'application depuis Chrome ou Edge');
  console.log('  (icone Installer dans la barre d\'adresse ou menu).');
  console.log('');
  console.log('  Fermez cette fenetre pour arreter.');
  console.log('');
});
