/* Service Worker for Audiobookshelf API Documentation
 * Provides offline caching and PWA functionality
 */

const CACHE_VERSION = 'abs-api-docs-v2.0.0';
const CACHE_NAME = `${CACHE_VERSION}`;

// Assets to cache immediately on install
const PRECACHE_URLS = [
  '/',
  '/index.html',
  '/stylesheets/screen.css',
  '/stylesheets/print.css',
  '/javascripts/all.js',
  '/javascripts/all_nosearch.js',
  '/images/logo.png',
  '/images/navbar.png'
];

// Runtime caching strategy
const RUNTIME_CACHE = `${CACHE_VERSION}-runtime`;

// Install event - precache essential assets
self.addEventListener('install', (event) => {
  console.log('[Service Worker] Installing...', CACHE_VERSION);

  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[Service Worker] Precaching assets');
        return cache.addAll(PRECACHE_URLS);
      })
      .then(() => {
        console.log('[Service Worker] Installation complete');
        // Immediately take control
        return self.skipWaiting();
      })
      .catch((error) => {
        console.error('[Service Worker] Precaching failed:', error);
      })
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('[Service Worker] Activating...', CACHE_VERSION);

  event.waitUntil(
    caches.keys()
      .then((cacheNames) => {
        return Promise.all(
          cacheNames
            .filter((cacheName) => {
              // Delete old versions
              return cacheName.startsWith('abs-api-docs-') &&
                     cacheName !== CACHE_NAME &&
                     cacheName !== RUNTIME_CACHE;
            })
            .map((cacheName) => {
              console.log('[Service Worker] Deleting old cache:', cacheName);
              return caches.delete(cacheName);
            })
        );
      })
      .then(() => {
        console.log('[Service Worker] Activation complete');
        // Take control of all clients
        return self.clients.claim();
      })
  );
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip non-GET requests
  if (request.method !== 'GET') {
    return;
  }

  // Skip cross-origin requests
  if (url.origin !== location.origin) {
    return;
  }

  event.respondWith(
    caches.match(request)
      .then((cachedResponse) => {
        if (cachedResponse) {
          console.log('[Service Worker] Serving from cache:', url.pathname);
          return cachedResponse;
        }

        // Not in cache, fetch from network
        return fetch(request)
          .then((response) => {
            // Don't cache non-successful responses
            if (!response || response.status !== 200 || response.type === 'error') {
              return response;
            }

            // Clone the response (can only be consumed once)
            const responseToCache = response.clone();

            // Cache successful responses
            caches.open(RUNTIME_CACHE)
              .then((cache) => {
                console.log('[Service Worker] Caching new resource:', url.pathname);
                cache.put(request, responseToCache);
              });

            return response;
          })
          .catch((error) => {
            console.error('[Service Worker] Fetch failed:', error);

            // Return offline page if available
            return caches.match('/offline.html').then((offlineResponse) => {
              if (offlineResponse) {
                return offlineResponse;
              }

              // Fallback error response
              return new Response('Offline - Network error occurred', {
                status: 503,
                statusText: 'Service Unavailable',
                headers: new Headers({
                  'Content-Type': 'text/plain'
                })
              });
            });
          });
      })
  );
});

// Message event - handle commands from clients
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    console.log('[Service Worker] Received SKIP_WAITING message');
    self.skipWaiting();
  }

  if (event.data && event.data.type === 'CLEAR_CACHE') {
    console.log('[Service Worker] Clearing all caches');
    event.waitUntil(
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => caches.delete(cacheName))
        );
      })
    );
  }

  if (event.data && event.data.type === 'CACHE_SIZE') {
    console.log('[Service Worker] Calculating cache size');
    event.waitUntil(
      caches.keys()
        .then((cacheNames) => {
          return Promise.all(
            cacheNames.map((cacheName) => {
              return caches.open(cacheName).then((cache) => {
                return cache.keys().then((requests) => {
                  return requests.length;
                });
              });
            })
          );
        })
        .then((counts) => {
          const total = counts.reduce((sum, count) => sum + count, 0);
          event.ports[0].postMessage({ cacheSize: total });
        })
    );
  }
});

// Background sync (for future use)
self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-progress') {
    console.log('[Service Worker] Background sync: progress');
    // Sync progress data when connection is restored
  }
});

// Push notifications (for future use)
self.addEventListener('push', (event) => {
  const data = event.data ? event.data.json() : {};

  const options = {
    body: data.body || 'New API documentation update available',
    icon: '/images/logo.png',
    badge: '/images/logo.png',
    vibrate: [200, 100, 200],
    data: {
      url: data.url || '/'
    }
  };

  event.waitUntil(
    self.registration.showNotification(
      data.title || 'Audiobookshelf API Docs',
      options
    )
  );
});

// Notification click
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  event.waitUntil(
    clients.openWindow(event.notification.data.url || '/')
  );
});

console.log('[Service Worker] Loaded', CACHE_VERSION);
