# Audiobookshelf API Quick Start Examples

## Table of Contents
1. [Authentication](#authentication)
2. [List Libraries](#list-libraries)
3. [Browse Library Items](#browse-library-items)
4. [Search for Books](#search-for-books)
5. [Start Playback](#start-playback)
6. [Track Progress](#track-progress)
7. [Share a Book](#share-a-book)
8. [Send to Kindle](#send-to-kindle)
9. [Get Statistics](#get-statistics)
10. [Manage API Keys](#manage-api-keys)

---

## Authentication

### Get Your API Token

```bash
# Login with username and password
curl -X POST "https://abs.example.com/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "your-username",
    "password": "your-password"
  }'
```

**Response:**
```json
{
  "user": {
    "id": "root",
    "username": "your-username",
    "token": "eyJhbGciOiJI...your-api-token-here...",
    "type": "admin"
  }
}
```

**Save your token:**
```bash
export ABS_TOKEN="eyJhbGciOiJI...your-api-token-here..."
export ABS_URL="https://abs.example.com"
```

### Using the Token

All subsequent requests use the token in the Authorization header:

```bash
curl "${ABS_URL}/api/me" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

Or as a query parameter for GET requests:

```bash
curl "${ABS_URL}/api/me?token=${ABS_TOKEN}"
```

---

## List Libraries

```bash
# Get all libraries
curl "${ABS_URL}/api/libraries" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**Response:**
```json
{
  "libraries": [
    {
      "id": "lib_c1u6t4p45c35rf0nzd",
      "name": "Audiobooks",
      "mediaType": "book",
      "folders": [
        {
          "id": "fol_bev1zuxhb0j0s1wehr",
          "fullPath": "/audiobooks"
        }
      ]
    },
    {
      "id": "lib_p9wkw2i85qy9oltijt",
      "name": "Podcasts",
      "mediaType": "podcast",
      "folders": [
        {
          "id": "fol_xyz123",
          "fullPath": "/podcasts"
        }
      ]
    }
  ]
}
```

**JavaScript Example:**
```javascript
async function getLibraries() {
  const response = await fetch(`${ABS_URL}/api/libraries`, {
    headers: {
      'Authorization': `Bearer ${ABS_TOKEN}`
    }
  });
  const data = await response.json();
  return data.libraries;
}
```

**Python Example:**
```python
import requests

def get_libraries():
    response = requests.get(
        f"{ABS_URL}/api/libraries",
        headers={"Authorization": f"Bearer {ABS_TOKEN}"}
    )
    return response.json()["libraries"]
```

---

## Browse Library Items

```bash
# Get items in a library (with pagination)
curl "${ABS_URL}/api/libraries/lib_c1u6t4p45c35rf0nzd/items?limit=10&page=0" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**With filters and sorting:**
```bash
# Get only audiobooks, sorted by title
curl "${ABS_URL}/api/libraries/lib_c1u6t4p45c35rf0nzd/items?limit=20&sort=media.metadata.title&filter=progress&minified=1" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**Response:**
```json
{
  "results": [
    {
      "id": "li_8gch9ve09orgn4fdz8",
      "media": {
        "metadata": {
          "title": "Wizards First Rule",
          "author": "Terry Goodkind",
          "narrator": "Sam Tsoutsouvas",
          "series": [
            {
              "name": "Sword of Truth",
              "sequence": "1"
            }
          ]
        },
        "duration": 33854.905
      }
    }
  ],
  "total": 150,
  "limit": 20,
  "page": 0
}
```

**JavaScript Example:**
```javascript
async function getLibraryItems(libraryId, page = 0, limit = 20) {
  const url = new URL(`${ABS_URL}/api/libraries/${libraryId}/items`);
  url.searchParams.append('limit', limit);
  url.searchParams.append('page', page);
  url.searchParams.append('sort', 'media.metadata.title');

  const response = await fetch(url, {
    headers: { 'Authorization': `Bearer ${ABS_TOKEN}` }
  });
  return await response.json();
}
```

---

## Search for Books

```bash
# Search across a library
curl "${ABS_URL}/api/libraries/lib_c1u6t4p45c35rf0nzd/search?q=sanderson" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**Advanced search:**
```bash
# Search with filters
curl "${ABS_URL}/api/libraries/lib_c1u6t4p45c35rf0nzd/search?q=fantasy&limit=10" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**Response:**
```json
{
  "book": [
    {
      "libraryItem": {
        "id": "li_8gch9ve09orgn4fdz8",
        "media": {
          "metadata": {
            "title": "The Way of Kings",
            "authorName": "Brandon Sanderson",
            "genres": ["Fantasy", "Epic Fantasy"]
          }
        }
      },
      "matchKey": "title",
      "matchText": "The Way of Kings"
    }
  ]
}
```

**JavaScript Search Function:**
```javascript
async function searchLibrary(libraryId, query) {
  const url = `${ABS_URL}/api/libraries/${libraryId}/search?q=${encodeURIComponent(query)}`;
  const response = await fetch(url, {
    headers: { 'Authorization': `Bearer ${ABS_TOKEN}` }
  });
  return await response.json();
}

// Usage
const results = await searchLibrary('lib_c1u6t4p45c35rf0nzd', 'Brandon Sanderson');
```

---

## Start Playback

```bash
# Start playing a book
curl -X POST "${ABS_URL}/api/items/li_8gch9ve09orgn4fdz8/play" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "deviceInfo": {
      "deviceId": "my-device-id",
      "clientName": "My App",
      "clientVersion": "1.0.0"
    },
    "supportedMimeTypes": [
      "audio/mpeg",
      "audio/mp4",
      "audio/flac"
    ]
  }'
```

**Start from specific position:**
```bash
curl -X POST "${ABS_URL}/api/items/li_8gch9ve09orgn4fdz8/play" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "deviceInfo": {
      "deviceId": "my-device-id",
      "clientName": "My App"
    },
    "forceDirectPlay": false,
    "forceTranscode": false,
    "mediaPlayer": "html5",
    "startTime": 1234.5
  }'
```

**Response:**
```json
{
  "id": "play_c786zm3qtjz6bd5q3n",
  "userId": "root",
  "libraryItemId": "li_8gch9ve09orgn4fdz8",
  "displayTitle": "Wizards First Rule",
  "displayAuthor": "Terry Goodkind",
  "coverPath": "/audiobooks/Terry Goodkind/.../cover.jpg",
  "duration": 33854.905,
  "playMethod": 0,
  "audioTracks": [
    {
      "index": 1,
      "startOffset": 0,
      "duration": 1854.905,
      "title": "Chapter 1",
      "contentUrl": "/api/items/li_8gch9ve09orgn4fdz8/file/audio_01.mp3?token=..."
    }
  ]
}
```

**JavaScript Playback Manager:**
```javascript
class AudiobookPlayer {
  constructor(absUrl, token) {
    this.absUrl = absUrl;
    this.token = token;
    this.sessionId = null;
  }

  async startPlayback(libraryItemId, startTime = 0) {
    const response = await fetch(
      `${this.absUrl}/api/items/${libraryItemId}/play`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          deviceInfo: {
            deviceId: this.getDeviceId(),
            clientName: 'Web Player',
            clientVersion: '1.0.0'
          },
          supportedMimeTypes: ['audio/mpeg', 'audio/mp4'],
          mediaPlayer: 'html5',
          startTime
        })
      }
    );

    const session = await response.json();
    this.sessionId = session.id;
    return session;
  }

  getDeviceId() {
    let deviceId = localStorage.getItem('deviceId');
    if (!deviceId) {
      deviceId = 'web_' + Math.random().toString(36).substr(2, 9);
      localStorage.setItem('deviceId', deviceId);
    }
    return deviceId;
  }
}

// Usage
const player = new AudiobookPlayer(ABS_URL, ABS_TOKEN);
const session = await player.startPlayback('li_8gch9ve09orgn4fdz8');
```

---

## Track Progress

### Update Progress During Playback

```bash
# Sync progress
curl -X PATCH "${ABS_URL}/api/me/progress/li_8gch9ve09orgn4fdz8" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "currentTime": 1234.5,
    "duration": 33854.905,
    "progress": 0.0365,
    "isFinished": false
  }'
```

### Sync Session Progress

```bash
# Update open session
curl -X POST "${ABS_URL}/api/session/play_c786zm3qtjz6bd5q3n/sync" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "currentTime": 1500.0,
    "timeListened": 265.5,
    "duration": 33854.905
  }'
```

### Get Your Progress

```bash
# Get progress for specific item
curl "${ABS_URL}/api/me/progress/li_8gch9ve09orgn4fdz8" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**Response:**
```json
{
  "id": "li_8gch9ve09orgn4fdz8",
  "libraryItemId": "li_8gch9ve09orgn4fdz8",
  "episodeId": null,
  "duration": 33854.905,
  "progress": 0.0443,
  "currentTime": 1500.0,
  "isFinished": false,
  "hideFromContinueListening": false,
  "lastUpdate": 1700000000000,
  "startedAt": 1699900000000,
  "finishedAt": null
}
```

**JavaScript Progress Tracker:**
```javascript
class ProgressTracker {
  constructor(absUrl, token) {
    this.absUrl = absUrl;
    this.token = token;
    this.syncInterval = null;
  }

  startTracking(libraryItemId, duration) {
    // Sync every 30 seconds
    this.syncInterval = setInterval(() => {
      this.syncProgress(libraryItemId, duration);
    }, 30000);
  }

  async syncProgress(libraryItemId, duration) {
    const currentTime = this.getCurrentTime(); // From your audio player
    const progress = currentTime / duration;

    await fetch(
      `${this.absUrl}/api/me/progress/${libraryItemId}`,
      {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${this.token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          currentTime,
          duration,
          progress,
          isFinished: progress >= 0.98
        })
      }
    );
  }

  stopTracking() {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
    }
  }
}
```

---

## Share a Book

### Create Share Link

```bash
# Create shareable link
curl -X POST "${ABS_URL}/api/share/mediaitem" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_8gch9ve09orgn4fdz8",
    "expiresAt": 1735689600000
  }'
```

**Response:**
```json
{
  "mediaItemShare": {
    "id": "shr_abc123",
    "slug": "happy-narwhal-42",
    "userId": "root",
    "libraryItemId": "li_8gch9ve09orgn4fdz8",
    "expiresAt": 1735689600000,
    "createdAt": 1700000000000
  }
}
```

**Share URL:** `https://abs.example.com/share/happy-narwhal-42`

### Access Shared Content (No Auth Required!)

```bash
# Get shared item details
curl "https://abs.example.com/api/share/happy-narwhal-42"

# Stream shared audio
curl "https://abs.example.com/api/share/happy-narwhal-42/track/0" -o chapter1.mp3

# Get cover
curl "https://abs.example.com/api/share/happy-narwhal-42/cover" -o cover.jpg
```

**JavaScript Share Manager:**
```javascript
async function createShare(libraryItemId, daysValid = 7) {
  const expiresAt = Date.now() + (daysValid * 24 * 60 * 60 * 1000);

  const response = await fetch(`${ABS_URL}/api/share/mediaitem`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${ABS_TOKEN}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      libraryItemId,
      expiresAt
    })
  });

  const data = await response.json();
  const shareUrl = `${ABS_URL}/share/${data.mediaItemShare.slug}`;

  return {
    id: data.mediaItemShare.id,
    slug: data.mediaItemShare.slug,
    url: shareUrl,
    expiresAt: new Date(expiresAt)
  };
}

// Usage
const share = await createShare('li_8gch9ve09orgn4fdz8', 7);
console.log(`Share URL: ${share.url}`);
console.log(`Expires: ${share.expiresAt}`);

// Copy to clipboard
navigator.clipboard.writeText(share.url);
```

---

## Send to Kindle

### Configure Email Settings (Admin)

```bash
# Set up SMTP
curl -X PATCH "${ABS_URL}/api/emails/settings" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "host": "smtp.gmail.com",
    "port": 587,
    "secure": false,
    "user": "your-email@gmail.com",
    "pass": "your-app-password",
    "fromAddress": "noreply@example.com"
  }'
```

### Configure Your Kindle

```bash
# Add your Kindle email
curl -X POST "${ABS_URL}/api/me/ereader-devices" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "ereaderDevices": [
      {
        "name": "My Kindle",
        "email": "mykindle_123@kindle.com"
      }
    ]
  }'
```

### Send Book to Kindle

```bash
# Send ebook to device
curl -X POST "${ABS_URL}/api/emails/send-ebook-to-device" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_8gch9ve09orgn4fdz8",
    "deviceName": "My Kindle"
  }'
```

**JavaScript Kindle Manager:**
```javascript
async function sendToKindle(libraryItemId, deviceName) {
  const response = await fetch(
    `${ABS_URL}/api/emails/send-ebook-to-device`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${ABS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        libraryItemId,
        deviceName
      })
    }
  );

  if (response.ok) {
    const data = await response.json();
    return { success: true, message: data.message };
  } else {
    throw new Error('Failed to send to Kindle');
  }
}

// Usage
try {
  await sendToKindle('li_8gch9ve09orgn4fdz8', 'My Kindle');
  alert('Book sent to your Kindle!');
} catch (error) {
  alert('Error: ' + error.message);
}
```

---

## Get Statistics

### Your Personal Stats

```bash
# Get your listening stats
curl "${ABS_URL}/api/me/listening-stats" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

### Year in Review

```bash
# Get stats for specific year
curl "${ABS_URL}/api/me/stats/year/2024" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**Response:**
```json
{
  "totalItems": 52,
  "totalAuthors": 15,
  "totalDuration": 87654.32,
  "totalListeningTime": 12345.67,
  "totalSessions": 156,
  "topGenres": [
    {
      "genre": "Science Fiction",
      "count": 23,
      "duration": 45678.9
    },
    {
      "genre": "Fantasy",
      "count": 18,
      "duration": 32145.6
    }
  ],
  "topAuthors": [
    {
      "authorId": "aut_xyz",
      "name": "Brandon Sanderson",
      "count": 8,
      "duration": 23456.78
    }
  ],
  "year": 2024
}
```

### Server Stats (Admin Only)

```bash
# Get server-wide statistics
curl "${ABS_URL}/api/stats/server" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**JavaScript Stats Dashboard:**
```javascript
async function getYearInReview(year = new Date().getFullYear()) {
  const response = await fetch(
    `${ABS_URL}/api/me/stats/year/${year}`,
    {
      headers: { 'Authorization': `Bearer ${ABS_TOKEN}` }
    }
  );
  const stats = await response.json();

  return {
    totalHours: (stats.totalListeningTime / 3600).toFixed(1),
    booksFinished: stats.recentlyFinished?.length || 0,
    topGenre: stats.topGenres[0]?.genre || 'None',
    topAuthor: stats.topAuthors[0]?.name || 'None',
    totalBooks: stats.totalItems
  };
}

// Display year in review
const stats = await getYearInReview(2024);
console.log(`
  📚 Your 2024 Year in Review

  Total listening time: ${stats.totalHours} hours
  Books finished: ${stats.booksFinished}
  Favorite genre: ${stats.topGenre}
  Favorite author: ${stats.topAuthor}
  Total books: ${stats.totalBooks}
`);
```

---

## Manage API Keys

### Create API Key (Admin)

```bash
# Create new API key
curl -X POST "${ABS_URL}/api/api-keys" \
  -H "Authorization: Bearer ${ABS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Mobile App",
    "expiresAt": 1735689600000
  }'
```

**Response:**
```json
{
  "apiKey": {
    "id": "apk_abc123",
    "name": "Mobile App",
    "key": "sk_xyz789abcdef...",
    "createdAt": 1700000000000,
    "expiresAt": 1735689600000,
    "isActive": true
  }
}
```

⚠️ **IMPORTANT**: Save the `key` value - it's only shown once!

### List API Keys

```bash
# Get all API keys
curl "${ABS_URL}/api/api-keys" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

### Revoke API Key

```bash
# Delete API key
curl -X DELETE "${ABS_URL}/api/api-keys/apk_abc123" \
  -H "Authorization: Bearer ${ABS_TOKEN}"
```

**JavaScript API Key Manager:**
```javascript
async function createApiKey(name, daysValid = 365) {
  const expiresAt = Date.now() + (daysValid * 24 * 60 * 60 * 1000);

  const response = await fetch(`${ABS_URL}/api/api-keys`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${ABS_TOKEN}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ name, expiresAt })
  });

  const data = await response.json();

  // IMPORTANT: Save this key securely!
  console.warn('⚠️ Save this key - it will not be shown again!');
  console.log('API Key:', data.apiKey.key);

  return data.apiKey;
}

// Usage
const apiKey = await createApiKey('Mobile App', 365);
// Save apiKey.key to secure storage!
```

---

## Complete Example: Book Listening App

```javascript
class AudiobookshelfClient {
  constructor(baseUrl) {
    this.baseUrl = baseUrl;
    this.token = null;
  }

  // Authentication
  async login(username, password) {
    const response = await fetch(`${this.baseUrl}/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    const data = await response.json();
    this.token = data.user.token;
    return data.user;
  }

  // Browse
  async getLibraries() {
    return this._fetch('/api/libraries');
  }

  async getLibraryItems(libraryId, page = 0) {
    return this._fetch(`/api/libraries/${libraryId}/items?page=${page}&limit=20`);
  }

  async searchLibrary(libraryId, query) {
    return this._fetch(`/api/libraries/${libraryId}/search?q=${encodeURIComponent(query)}`);
  }

  // Playback
  async startPlayback(libraryItemId) {
    return this._fetch(`/api/items/${libraryItemId}/play`, {
      method: 'POST',
      body: JSON.stringify({
        deviceInfo: {
          deviceId: this.getDeviceId(),
          clientName: 'Demo App'
        },
        supportedMimeTypes: ['audio/mpeg', 'audio/mp4']
      })
    });
  }

  async updateProgress(libraryItemId, currentTime, duration) {
    return this._fetch(`/api/me/progress/${libraryItemId}`, {
      method: 'PATCH',
      body: JSON.stringify({
        currentTime,
        duration,
        progress: currentTime / duration,
        isFinished: false
      })
    });
  }

  // Share
  async createShare(libraryItemId, daysValid = 7) {
    const expiresAt = Date.now() + (daysValid * 24 * 60 * 60 * 1000);
    const data = await this._fetch('/api/share/mediaitem', {
      method: 'POST',
      body: JSON.stringify({ libraryItemId, expiresAt })
    });
    return `${this.baseUrl}/share/${data.mediaItemShare.slug}`;
  }

  // Helper method
  async _fetch(path, options = {}) {
    const response = await fetch(`${this.baseUrl}${path}`, {
      ...options,
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'Content-Type': 'application/json',
        ...options.headers
      }
    });
    return await response.json();
  }

  getDeviceId() {
    let id = localStorage.getItem('deviceId');
    if (!id) {
      id = 'web_' + Math.random().toString(36).substr(2, 9);
      localStorage.setItem('deviceId', id);
    }
    return id;
  }
}

// Usage Example
const client = new AudiobookshelfClient('https://abs.example.com');

// Login
await client.login('username', 'password');

// Browse libraries
const libraries = await client.getLibraries();
const bookLibrary = libraries.libraries.find(lib => lib.mediaType === 'book');

// Search for books
const searchResults = await client.searchLibrary(bookLibrary.id, 'Sanderson');
const firstBook = searchResults.book[0].libraryItem;

// Start listening
const session = await client.startPlayback(firstBook.id);

// Update progress every 30 seconds
setInterval(async () => {
  await client.updateProgress(
    firstBook.id,
    audioPlayer.currentTime,
    session.duration
  );
}, 30000);

// Share with a friend
const shareUrl = await client.createShare(firstBook.id, 7);
console.log('Share this URL:', shareUrl);
```

---

## Python Example

```python
import requests
from typing import Optional, Dict, Any

class AudiobookshelfClient:
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.token: Optional[str] = None
        self.session = requests.Session()

    def login(self, username: str, password: str) -> Dict[str, Any]:
        """Authenticate and store token"""
        response = self.session.post(
            f"{self.base_url}/login",
            json={"username": username, "password": password}
        )
        response.raise_for_status()
        data = response.json()
        self.token = data['user']['token']
        self.session.headers.update({
            'Authorization': f'Bearer {self.token}'
        })
        return data['user']

    def get_libraries(self) -> list:
        """Get all libraries"""
        response = self.session.get(f"{self.base_url}/api/libraries")
        response.raise_for_status()
        return response.json()['libraries']

    def search_library(self, library_id: str, query: str) -> Dict[str, Any]:
        """Search for items in a library"""
        response = self.session.get(
            f"{self.base_url}/api/libraries/{library_id}/search",
            params={'q': query}
        )
        response.raise_for_status()
        return response.json()

    def start_playback(self, library_item_id: str) -> Dict[str, Any]:
        """Start playback session"""
        response = self.session.post(
            f"{self.base_url}/api/items/{library_item_id}/play",
            json={
                'deviceInfo': {
                    'deviceId': 'python-client',
                    'clientName': 'Python Demo'
                },
                'supportedMimeTypes': ['audio/mpeg', 'audio/mp4']
            }
        )
        response.raise_for_status()
        return response.json()

    def update_progress(
        self,
        library_item_id: str,
        current_time: float,
        duration: float
    ) -> Dict[str, Any]:
        """Update listening progress"""
        response = self.session.patch(
            f"{self.base_url}/api/me/progress/{library_item_id}",
            json={
                'currentTime': current_time,
                'duration': duration,
                'progress': current_time / duration,
                'isFinished': False
            }
        )
        response.raise_for_status()
        return response.json()

# Usage
client = AudiobookshelfClient('https://abs.example.com')
client.login('username', 'password')

# Get libraries
libraries = client.get_libraries()
book_library = next(lib for lib in libraries if lib['mediaType'] == 'book')

# Search
results = client.search_library(book_library['id'], 'Sanderson')
first_book = results['book'][0]['libraryItem']

# Start playback
session = client.start_playback(first_book['id'])
print(f"Now playing: {session['displayTitle']}")
```

---

## More Examples

For more examples and detailed documentation, see:
- [Full API Documentation](https://api.audiobookshelf.org)
- [API Migration Guide](API_MIGRATION_GUIDE.md)
- [Code Review](CODE_REVIEW.md)

---

**Happy coding!** 🚀
