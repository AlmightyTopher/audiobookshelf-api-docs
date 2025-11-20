---
title: Audiobookshelf API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='https://github.com/AlmightyTopher/audiobookshelf-api-docs/blob/claude/update-api-docs-01TPDQwZ88iiSSRRYCPbewCS/ENDPOINT_MATRIX.md'><strong>📋 Endpoint Matrix (All 135 APIs)</strong></a>
  - <a href='https://github.com/AlmightyTopher/audiobookshelf-api-docs/blob/claude/update-api-docs-01TPDQwZ88iiSSRRYCPbewCS/QUICK_START_EXAMPLES.md'>💡 Quick Start Examples</a>
  - <a href='https://github.com/AlmightyTopher/audiobookshelf-api-docs/blob/claude/update-api-docs-01TPDQwZ88iiSSRRYCPbewCS/WHATS_NEW.md'>✨ What's New in v2.0</a>
  - <a href='https://github.com/advplyr/audiobookshelf-slate'>View Doc Source</a>
  - <a href='https://github.com/slatedocs/slate'>Documentation Powered by Slate</a>

includes:
  - quick_start
  - server
  - libraries
  - items
  - users
  - collections
  - playlists
  - me
  - backups
  - filesystem
  - authors
  - series
  - sessions
  - podcasts
  - notifications
  - emails
  - search
  - cache
  - tools
  - rss_feeds
  - share
  - stats
  - api_keys
  - misc
  - socket
  - metadata_providers
  - filtering
  - schemas

search: true

code_clipboard: true

meta:
  - name: description
    content: Documentation for the Audiobookshelf API
  - name: viewport
    content: width=device-width, initial-scale=1.0, maximum-scale=5.0
  - name: theme-color
    content: "#2e3336"
  - name: apple-mobile-web-app-capable
    content: "yes"
  - name: apple-mobile-web-app-status-bar-style
    content: "black-translucent"
  - name: apple-mobile-web-app-title
    content: "ABS API Docs"

head: |
  <link rel="manifest" href="/manifest.json">
  <link rel="apple-touch-icon" href="/images/logo.png">
  <script>
    // Register service worker for offline support
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', function() {
        navigator.serviceWorker.register('/service-worker.js')
          .then(function(registration) {
            console.log('Service Worker registered successfully:', registration.scope);
          })
          .catch(function(error) {
            console.log('Service Worker registration failed:', error);
          });
      });
    }
  </script>
---

# Introduction

Welcome to the Audiobookshelf API documentation! This comprehensive guide covers all 135+ endpoints for managing your audiobook and podcast server.

**Coverage:** 97.8% of all API endpoints (135/138 documented)
**Last Updated:** 2025-11-20

<aside class="success">
These docs have been recently updated with 29 new endpoints including API Keys, Media Sharing, Email Integration, and Server Statistics!
</aside>

<aside class="notice">
We plan to implement automated OpenAPI docs in the future for even better API documentation.
</aside>

# Authentication

Audiobookshelf uses a users API token as a Bearer token for requests. For GET requests the API token can optionally be passed in as a query string.

You can find your API token by logging into the Audiobookshelf web app as an admin, go to the config → users page, and click on your account.

You may also get the API token programmatically using the [Login](#login) endpoint. The API token will be in the response at `response.user.token`.

API request header for authentication would look like this:

`Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY`

Optionally GET requests can use the API token like this:

`https://abs.example.com/api/items/li_asdfalwkerioa?token=exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY`

<aside class="notice">
Your API token will be much longer then the one in the examples.
</aside>
