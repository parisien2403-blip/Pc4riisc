const CACHE_NAME = 'trigone-pc-portail-v2';
const ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './sw.js',
  './logo-portail.png',
  './logo application.png',
  './icon-192.png',
  './icon-512.png',
  './icon-maskable-512.png',
  './apple-touch-icon.png',
  './new validation omr.png',
  './omr/index.html',
  './omr/manifest.json',
  './omr/sw.js',
  './omr/logo omr.png',
  './omr/phonix.png',
  './omr/icon-192.png',
  './omr/icon-512.png',
  './abt/index.html',
  './abt/manifest.json',
  './abt/sw.js',
  './abt/logo abt.png',
  './abt/logo.jpg',
  './abt/phonix.png',
  './abt/icon-192.png',
  './abt/icon-512.png'
];

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      return Promise.all(ASSETS.map(function (u) {
        return cache.add(u).catch(function () {});
      }));
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(
        keys.filter(function (k) { return k !== CACHE_NAME; }).map(function (k) { return caches.delete(k); })
      );
    })
  );
  self.clients.claim();
});

self.addEventListener('fetch', function (event) {
  if (event.request.method !== 'GET') return;
  event.respondWith(
    caches.match(event.request).then(function (cached) {
      var network = fetch(event.request).then(function (response) {
        if (response && response.status === 200) {
          var copy = response.clone();
          caches.open(CACHE_NAME).then(function (cache) { cache.put(event.request, copy); });
        }
        return response;
      }).catch(function () { return cached; });
      return cached || network;
    })
  );
});
