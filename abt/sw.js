const CACHE_NAME = 'abt2-v46';
const ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './manifest.webmanifest',
  '../theme-app.css',
  './sw.js',
  './logo.png',
  './logo.jpg',
  './icon-192.png',
  './icon-512.png',
  './icon-maskable-192.png',
  './icon-maskable-512.png',
  './apple-touch-icon.png',
  './logo abt.png',
  './images/prestations/hotel.jpg',
  './images/prestations/train.jpg',
  './images/prestations/avion.jpg',
  './images/prestations/ferry.jpg',
  './images/prestations/vehicule.jpg',
  './images/hero-crest.png'
];

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      return cache.addAll(ASSETS);
    }).catch(function () {})
  );
  self.skipWaiting();
});

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(keys.filter(function (k) { return k !== CACHE_NAME; }).map(function (k) {
        return caches.delete(k);
      }));
    })
  );
  self.clients.claim();
});

self.addEventListener('fetch', function (event) {
  if (event.request.method !== 'GET') return;
  event.respondWith(
    caches.match(event.request).then(function (cached) {
      return cached || fetch(event.request);
    })
  );
});
