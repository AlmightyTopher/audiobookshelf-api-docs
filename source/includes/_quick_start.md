# Quick Start

Get up and running with the Audiobookshelf API in minutes. These examples demonstrate common workflows for integrating with your audiobook and podcast server.

## Basic Authentication

```shell
# Login to get your API token
curl -X POST "https://abs.example.com/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "your_username",
    "password": "your_password"
  }'

# Response includes your token
# {
#   "user": {
#     "token": "eyJhbGci...",
#     "username": "your_username",
#     ...
#   }
# }

# Use the token for authenticated requests
curl "https://abs.example.com/api/libraries" \
  -H "Authorization: Bearer eyJhbGci..."
```

<aside class="notice">
Save your token securely! You'll need it for all authenticated API requests.
</aside>

## List Your Libraries

```shell
curl "https://abs.example.com/api/libraries" \
  -H "Authorization: Bearer your_token"
```

> Response includes all your libraries:

```json
{
  "libraries": [
    {
      "id": "lib_123",
      "name": "Audiobooks",
      "mediaType": "book",
      "folders": [...]
    },
    {
      "id": "lib_456",
      "name": "Podcasts",
      "mediaType": "podcast",
      "folders": [...]
    }
  ]
}
```

## Browse Library Items

```shell
# Get items from a specific library
curl "https://abs.example.com/api/libraries/lib_123/items?limit=10" \
  -H "Authorization: Bearer your_token"

# Search for a specific book
curl "https://abs.example.com/api/libraries/lib_123/search?q=dune" \
  -H "Authorization: Bearer your_token"
```

> Search returns matching items:

```json
{
  "book": [
    {
      "libraryItem": {
        "id": "li_abc123",
        "media": {
          "metadata": {
            "title": "Dune",
            "author": "Frank Herbert"
          }
        }
      }
    }
  ]
}
```

## Start Playback

```shell
# Start a playback session for an audiobook
curl -X POST "https://abs.example.com/api/items/li_abc123/play" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "deviceInfo": {
      "deviceId": "my_device_123"
    },
    "supportedMimeTypes": ["audio/mpeg", "audio/mp4"]
  }'
```

> Returns playback session with streaming URLs:

```json
{
  "id": "play_session_xyz",
  "userId": "user_123",
  "libraryItemId": "li_abc123",
  "audioTracks": [
    {
      "index": 1,
      "startOffset": 0,
      "duration": 3600.5,
      "contentUrl": "/s/play_session_xyz/0",
      "mimeType": "audio/mpeg"
    }
  ]
}
```

<aside class="notice">
The contentUrl is relative. Prepend your server URL to stream audio.
</aside>

## Track Your Progress

```shell
# Update listening progress
curl -X PATCH "https://abs.example.com/api/me/progress/li_abc123" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "currentTime": 1234.5,
    "isFinished": false
  }'

# Get your progress
curl "https://abs.example.com/api/me/progress/li_abc123" \
  -H "Authorization: Bearer your_token"
```

> Progress response:

```json
{
  "id": "li_abc123",
  "userId": "user_123",
  "libraryItemId": "li_abc123",
  "currentTime": 1234.5,
  "isFinished": false,
  "progress": 0.34
}
```

## Share a Book

```shell
# Create a shareable link (expires in 7 days)
curl -X POST "https://abs.example.com/api/share/mediaitem" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_abc123",
    "expiresAt": null
  }'
```

> Returns a public share link:

```json
{
  "id": "shr_xyz",
  "slug": "happy-narwhal-42",
  "libraryItemId": "li_abc123",
  "expiresAt": null
}
```

**Share URL:** `https://abs.example.com/share/happy-narwhal-42`

<aside class="success">
Share links don't require authentication - perfect for sharing with friends!
</aside>

## Send to Kindle

```shell
# First, configure SMTP settings (admin only)
curl -X PATCH "https://abs.example.com/api/emails/settings" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "host": "smtp.gmail.com",
    "port": 587,
    "secure": false,
    "user": "your_email@gmail.com",
    "pass": "your_app_password",
    "fromAddress": "your_email@gmail.com"
  }'

# Send an ebook to your Kindle
curl -X POST "https://abs.example.com/api/emails/send-ebook-to-device" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_abc123",
    "deviceName": "My Kindle"
  }'
```

<aside class="warning">
Configure your eReader devices first using the "Update Your eReader Devices" endpoint.
</aside>

## Get Statistics

```shell
# Get your personal listening stats
curl "https://abs.example.com/api/me/listening-stats" \
  -H "Authorization: Bearer your_token"

# Get stats for a specific year
curl "https://abs.example.com/api/me/stats/year/2024" \
  -H "Authorization: Bearer your_token"

# Get server-wide stats (admin only)
curl "https://abs.example.com/api/stats/server" \
  -H "Authorization: Bearer your_token"
```

> Your listening stats:

```json
{
  "totalTime": 259200,
  "items": {
    "li_abc123": {
      "id": "li_abc123",
      "timeListening": 3600,
      "mediaMetadata": {
        "title": "Dune"
      }
    }
  },
  "days": {
    "2024-01-15": 7200
  },
  "dayOfWeek": {
    "Monday": 36000,
    "Tuesday": 28800
  }
}
```

## Manage API Keys

```shell
# Create an API key for external integrations
curl -X POST "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "userIdOrUsername": "api_user"
  }'
```

> API key response (save this - it won't be shown again!):

```json
{
  "apiKey": {
    "id": "apk_xyz",
    "key": "abs_api_super_secret_key_123456",
    "userId": "user_123",
    "createdAt": 1234567890,
    "expiresAt": null
  }
}
```

<aside class="warning">
API keys are only displayed once! Save them securely immediately after creation.
</aside>

## Working with RSS Feeds

```shell
# Create an RSS feed for a collection
curl -X POST "https://abs.example.com/api/feeds/collection/col_123/open" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "serverAddress": "https://abs.example.com",
    "slug": "my-favorite-books"
  }'
```

> RSS feed response:

```json
{
  "feed": {
    "id": "feed_xyz",
    "slug": "my-favorite-books",
    "entityType": "collection",
    "entityId": "col_123",
    "feedUrl": "https://abs.example.com/feed/my-favorite-books"
  }
}
```

**RSS URL:** `https://abs.example.com/feed/my-favorite-books`

<aside class="notice">
RSS feeds are great for podcast apps! Subscribe to your library in any podcast player.
</aside>

## Complete Example: JavaScript Client

```javascript
class AudiobookshelfClient {
  constructor(serverUrl) {
    this.serverUrl = serverUrl;
    this.token = null;
  }

  async login(username, password) {
    const response = await fetch(`${this.serverUrl}/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    const data = await response.json();
    this.token = data.user.token;
    return data.user;
  }

  async getLibraries() {
    const response = await fetch(`${this.serverUrl}/api/libraries`, {
      headers: { 'Authorization': `Bearer ${this.token}` }
    });
    return response.json();
  }

  async searchLibrary(libraryId, query) {
    const url = `${this.serverUrl}/api/libraries/${libraryId}/search?q=${encodeURIComponent(query)}`;
    const response = await fetch(url, {
      headers: { 'Authorization': `Bearer ${this.token}` }
    });
    return response.json();
  }

  async startPlayback(libraryItemId, deviceId = 'web_player') {
    const response = await fetch(
      `${this.serverUrl}/api/items/${libraryItemId}/play`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          deviceInfo: { deviceId },
          supportedMimeTypes: ['audio/mpeg', 'audio/mp4']
        })
      }
    );
    return response.json();
  }

  async updateProgress(libraryItemId, currentTime, isFinished = false) {
    const response = await fetch(
      `${this.serverUrl}/api/me/progress/${libraryItemId}`,
      {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${this.token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ currentTime, isFinished })
      }
    );
    return response.json();
  }
}

// Usage:
const client = new AudiobookshelfClient('https://abs.example.com');
await client.login('username', 'password');
const libraries = await client.getLibraries();
const results = await client.searchLibrary('lib_123', 'dune');
const session = await client.startPlayback('li_abc123');
```

## Complete Example: Python Client

```python
import requests
from typing import Dict, Any, Optional

class AudiobookshelfClient:
    def __init__(self, server_url: str):
        self.server_url = server_url.rstrip('/')
        self.token: Optional[str] = None

    def login(self, username: str, password: str) -> Dict[str, Any]:
        response = requests.post(
            f'{self.server_url}/login',
            json={'username': username, 'password': password}
        )
        response.raise_for_status()
        data = response.json()
        self.token = data['user']['token']
        return data['user']

    def _headers(self) -> Dict[str, str]:
        return {'Authorization': f'Bearer {self.token}'}

    def get_libraries(self) -> Dict[str, Any]:
        response = requests.get(
            f'{self.server_url}/api/libraries',
            headers=self._headers()
        )
        response.raise_for_status()
        return response.json()

    def search_library(self, library_id: str, query: str) -> Dict[str, Any]:
        response = requests.get(
            f'{self.server_url}/api/libraries/{library_id}/search',
            params={'q': query},
            headers=self._headers()
        )
        response.raise_for_status()
        return response.json()

    def start_playback(self, library_item_id: str, device_id: str = 'python_client') -> Dict[str, Any]:
        response = requests.post(
            f'{self.server_url}/api/items/{library_item_id}/play',
            json={
                'deviceInfo': {'deviceId': device_id},
                'supportedMimeTypes': ['audio/mpeg', 'audio/mp4']
            },
            headers=self._headers()
        )
        response.raise_for_status()
        return response.json()

    def update_progress(self, library_item_id: str, current_time: float, is_finished: bool = False) -> Dict[str, Any]:
        response = requests.patch(
            f'{self.server_url}/api/me/progress/{library_item_id}',
            json={'currentTime': current_time, 'isFinished': is_finished},
            headers=self._headers()
        )
        response.raise_for_status()
        return response.json()

    def create_share(self, library_item_id: str, days_valid: Optional[int] = 7) -> Dict[str, Any]:
        import time
        expires_at = int((time.time() + days_valid * 86400) * 1000) if days_valid else None

        response = requests.post(
            f'{self.server_url}/api/share/mediaitem',
            json={'libraryItemId': library_item_id, 'expiresAt': expires_at},
            headers=self._headers()
        )
        response.raise_for_status()
        return response.json()

# Usage:
client = AudiobookshelfClient('https://abs.example.com')
user = client.login('username', 'password')
libraries = client.get_libraries()
results = client.search_library('lib_123', 'dune')
session = client.start_playback('li_abc123')
```

## Next Steps

Now that you've seen the basics, explore the full API documentation:

- **[Libraries](#libraries)** - Manage your media libraries
- **[Library Items](#library-items)** - Access books and podcasts
- **[Users](#users)** - User management (admin)
- **[Sessions](#sessions)** - Track playback sessions
- **[Collections](#collections)** - Organize your media
- **[Playlists](#playlists)** - Create custom playlists
- **[Share](#share)** - Share media with others
- **[Emails](#emails)** - Send ebooks to eReaders
- **[API Keys](#api-keys)** - Manage API authentication

### Additional Resources

- **[Endpoint Matrix](ENDPOINT_MATRIX.md)** - Complete list of all 138 endpoints with direct links
- **[API Coverage Report](API_COVERAGE_REPORT.md)** - Detailed coverage analysis
- **[Migration Guide](API_MIGRATION_GUIDE.md)** - Upgrading from previous versions

<aside class="success">
Ready to build? All endpoints are documented with request/response examples!
</aside>
