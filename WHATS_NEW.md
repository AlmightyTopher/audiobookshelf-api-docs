# What's New in the API Documentation

**Documentation Version:** 2.0 (2025-11-20)
**Coverage:** 135/138 endpoints (97.8%)
**New Endpoints:** 29
**Updated Sections:** 8

---

## 🎉 Major Updates

### New API Sections

#### 1. **API Keys Management** (NEW!)

Programmatically manage API keys for external integrations and automation.

**New Endpoints:**
- `GET /api/api-keys` - List all API keys
- `POST /api/api-keys` - Create a new API key
- `PATCH /api/api-keys/:id` - Update an API key
- `DELETE /api/api-keys/:id` - Revoke an API key

**Why it matters:** Secure API access for third-party apps, CI/CD pipelines, and automation scripts without exposing user passwords.

**Example use case:**
```bash
# Create an API key for a monitoring script
curl -X POST "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer admin_token" \
  -H "Content-Type: application/json" \
  -d '{"userIdOrUsername": "monitoring"}'
```

**Documentation:** [API Keys](#api-keys)

---

#### 2. **Media Sharing** (NEW!)

Share audiobooks and podcasts with friends using public, password-free links.

**New Endpoints:**
- `POST /api/share/mediaitem` - Create a shareable link
- `DELETE /api/share/mediaitem/:id` - Revoke a share
- `GET /api/share/:slug` - Access shared media (public, no auth!)
- `GET /api/share/:slug/track/:index` - Stream audio (public)
- `GET /api/share/:slug/cover` - Get cover image (public)
- `GET /api/share/:slug/download` - Download media (public)
- `PATCH /api/share/:slug/progress` - Track progress (public)

**Why it matters:** Easily share your favorite books with friends without requiring them to create an account or authenticate.

**Example use case:**
```bash
# Share a book with a friend
curl -X POST "https://abs.example.com/api/share/mediaitem" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{"libraryItemId": "li_abc123"}'

# Returns: {"slug": "happy-narwhal-42"}
# Share URL: https://abs.example.com/share/happy-narwhal-42
```

**Key Features:**
- Human-readable slugs (e.g., "happy-narwhal-42")
- Optional expiration dates
- No authentication required for access
- Progress tracking for shared items

**Documentation:** [Share](#share)

---

#### 3. **Email & eReader Integration** (NEW!)

Send ebooks directly to Kindle, Kobo, and other eReaders via email.

**New Endpoints:**
- `GET /api/emails/settings` - Get SMTP configuration
- `PATCH /api/emails/settings` - Configure email settings
- `POST /api/emails/test` - Test email configuration
- `POST /api/emails/ereader-devices` - Manage eReader devices (admin)
- `POST /api/emails/send-ebook-to-device` - Send ebook to device

**Why it matters:** Seamless integration with eReaders - send books directly to your Kindle email address with automatic format conversion.

**Example use case:**
```bash
# Send an EPUB to Kindle (automatically converted to MOBI)
curl -X POST "https://abs.example.com/api/emails/send-ebook-to-device" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_abc123",
    "deviceName": "My Kindle"
  }'
```

**Key Features:**
- Automatic format conversion (EPUB → MOBI for Kindle)
- Multiple device support
- SMTP configuration per server
- Test emails to verify setup

**Documentation:** [Emails](#emails)

---

#### 4. **Server Statistics** (NEW!)

Access comprehensive server-wide statistics and analytics.

**New Endpoints:**
- `GET /api/stats/year/:year` - Get yearly statistics
- `GET /api/stats/server` - Get server statistics

**Why it matters:** Admin insights into server usage, library growth, and user engagement.

**Example response:**
```json
{
  "totalItems": 1500,
  "totalAuthors": 250,
  "totalGenres": 45,
  "totalDuration": 5400000,
  "longestItems": [...],
  "numAudioTracks": 15000
}
```

**Documentation:** [Stats](#stats)

---

### Enhanced Existing Sections

#### 5. **Libraries** - 8 New Endpoints

**New capabilities:**
- **Narrator Management:**
  - `GET /api/libraries/:id/narrators` - List all narrators
  - `PATCH /api/libraries/:id/narrators/:narratorId` - Update narrator info
  - `DELETE /api/libraries/:id/narrators/:narratorId` - Remove/merge narrator

- **Series Access:**
  - `GET /api/libraries/:id/series/:seriesId` - Get specific series details

- **Import/Export:**
  - `GET /api/libraries/:id/opml` - Export podcast library as OPML

- **Bulk Operations:**
  - `GET /api/libraries/:id/podcast-titles` - List all podcast titles
  - `GET /api/libraries/:id/download` - Bulk download library items
  - `POST /api/libraries/:id/remove-metadata` - Clean up metadata files

**Why it matters:**
- Better narrator organization and cleanup
- Easy podcast library migration with OPML
- Bulk operations for large libraries

**Documentation:** [Libraries](#libraries)

---

#### 6. **Me (Current User)** - 3 New Endpoints

**New capabilities:**
- `GET /api/me/stats/year/:year` - Your yearly listening stats
- `POST /api/me/series/:id/readd-from-continue-listening` - Re-add removed series
- `POST /api/me/ereader-devices` - Manage your personal eReader devices

**Why it matters:** Year-in-review statistics, better series management, personal device configuration.

**Example:**
```bash
# Get your 2024 listening stats
curl "https://abs.example.com/api/me/stats/year/2024" \
  -H "Authorization: Bearer your_token"

# Returns detailed breakdown by month, genre, authors
```

**Documentation:** [Me](#me-current-user)

---

#### 7. **Sessions** - 2 New Endpoints

**New capabilities:**
- `GET /api/sessions/open` - List all currently active sessions
- `POST /api/sessions/batch/delete` - Bulk delete multiple sessions

**Why it matters:** Monitor active users, clean up old sessions, manage server resources.

**Documentation:** [Sessions](#sessions)

---

#### 8. **Users** - 1 New Endpoint

**New capability:**
- `PATCH /api/users/:id/openid-unlink` - Unlink user's OpenID/SSO account

**Why it matters:** Allow users to disconnect SSO authentication while keeping their account.

**Documentation:** [Users](#users)

---

#### 9. **Items** - 1 New Endpoint

**New capability:**
- `POST /api/items/batch/scan` - Scan multiple library items at once

**Why it matters:** Faster library updates when metadata or files change.

**Documentation:** [Library Items](#library-items)

---

#### 10. **Metadata Providers** - Restructured

**Changes:**
- Separated **custom providers** (CRUD operations) from **built-in providers** (reference)
- New CRUD endpoints for custom metadata providers:
  - `GET /api/custom-metadata-providers`
  - `POST /api/custom-metadata-providers`
  - `DELETE /api/custom-metadata-providers/:id`

**Why it matters:** Configure custom metadata sources for books not in standard databases.

**Documentation:** [Metadata Providers](#metadata-providers)

---

#### 11. **Miscellaneous** - 6 New Endpoints

**New capabilities:**
- **Authentication Settings:**
  - `GET /api/auth-settings` - Get authentication configuration
  - `PATCH /api/auth-settings` - Update auth settings

- **Sorting Preferences:**
  - `GET /api/sorting-prefixes` - Get title sorting prefixes

- **System Monitoring:**
  - `POST /api/watcher/update` - Update file watcher settings
  - `GET /api/logger-data` - Access server logs
  - `GET /api/tasks` - List running tasks

**Why it matters:** Server administration, monitoring, and customization.

**Documentation:** [Miscellaneous](#miscellaneous)

---

## 📊 Coverage Improvements

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| **Documented Endpoints** | ~105 | 135 | +30 🎉 |
| **Coverage** | ~76% | 97.8% | +21.8% 📈 |
| **API Sections** | 20 | 24 | +4 🆕 |
| **Documentation Pages** | 28 | 32 | +4 📄 |
| **Total Documentation** | ~400 KB | ~600 KB | +50% 📚 |

---

## 🔍 What's Missing?

Only 3 endpoints remain undocumented (2.2%):

1. **`POST /api/auth/password-reset-request`** - Internal password reset flow
2. **`GET /feed/:slug`** - Alternative RSS feed URL (duplicates `/api/feeds`)
3. **`POST /auth/openid/token-refresh`** - Internal OAuth token refresh

**Priority:** Low - These are either internal endpoints or duplicates of documented functionality.

---

## 🚀 New Documentation Features

### 1. **Quick Start Guide**

New getting-started section with complete examples in:
- **Shell/curl** - Direct HTTP requests
- **JavaScript** - Complete `AudiobookshelfClient` class
- **Python** - Full Python client implementation

**Includes 10 common workflows:**
1. Authentication & login
2. Listing libraries
3. Browsing items
4. Searching content
5. Starting playback
6. Tracking progress
7. Sharing media
8. Sending to Kindle
9. Viewing statistics
10. Managing API keys

**Location:** [Quick Start](#quick-start)

---

### 2. **Endpoint Matrix**

Complete reference table of all 135 endpoints with:
- HTTP method and path
- Documentation link with anchor
- Source file reference
- Coverage status
- Category grouping

**Location:** `ENDPOINT_MATRIX.md`

**Example:**
```
| # | Method | Endpoint | Documentation Link | Source File |
|---|--------|----------|-------------------|-------------|
| 1 | GET | /api/libraries | [Get All Libraries](#get-all-libraries) | _libraries.md:75 |
```

---

### 3. **API Coverage Report**

Detailed analysis document showing:
- Endpoint-by-endpoint comparison
- Documented vs implemented status
- Missing endpoint identification
- Priority ratings
- Coverage percentages by category

**Location:** `API_COVERAGE_REPORT.md`

---

### 4. **Build Verification**

Complete build verification report confirming:
- No build errors
- All sections render correctly
- Syntax highlighting works
- Navigation links functional
- Assets properly generated

**Location:** `BUILD_VERIFICATION.md`

---

## 🎨 Documentation Improvements

### Better Organization

- **24 categorized sections** (was 20)
- **Logical grouping** of related endpoints
- **Consistent formatting** across all endpoints
- **Improved navigation** with expanded table of contents

### Enhanced Examples

- **Request examples** for every endpoint
- **Response examples** with real data structures
- **Error responses** documented
- **Authentication headers** in all examples
- **Query parameters** explained

### Security Notices

Added security warnings and notices for:
- API key creation (one-time display)
- Admin-only endpoints
- Public (unauthenticated) endpoints
- Token expiration
- Password requirements

### Better Descriptions

- **Use case explanations** for each endpoint
- **Parameter tables** with types and requirements
- **Response field descriptions**
- **Status code documentation**
- **Best practices** and recommendations

---

## 🔄 Breaking Changes

**None!** This is a documentation update only. All existing endpoints remain unchanged and backwards compatible.

---

## 📅 Version History

### Version 2.0 (2025-11-20) - Major Documentation Update

**Added:**
- 29 new endpoints documented
- 4 new API sections (API Keys, Share, Emails, Stats)
- Quick Start guide with code examples
- Endpoint matrix reference
- API coverage report
- Build verification

**Changed:**
- Restructured metadata providers documentation
- Updated introduction with coverage stats
- Enhanced navigation and organization
- Improved example quality

**Fixed:**
- Corrected numerous endpoint descriptions
- Fixed parameter documentation
- Updated response examples
- Improved error documentation

### Version 1.0 (Pre-2025) - Initial Documentation

**Included:**
- ~105 endpoints documented (~76% coverage)
- Basic request/response examples
- Authentication guide
- Schema definitions

---

## 🎯 Migration Guide

### If You Were Using Undocumented Endpoints

**Great news!** If you were using any of the newly documented endpoints, your code will continue to work exactly as before. This is a documentation update only - no API changes.

### New Capabilities to Explore

**Recommended adoption priorities:**

1. **High Priority - Immediate Value:**
   - **API Keys** - Secure your integrations
   - **Media Sharing** - Share content easily
   - **Statistics** - Gain insights

2. **Medium Priority - Enhanced Features:**
   - **Email Integration** - eReader support
   - **Narrator Management** - Better organization
   - **Batch Operations** - Efficiency improvements

3. **Low Priority - Nice to Have:**
   - **Sorting Prefixes** - Customization
   - **OpenID Unlinking** - Account management
   - **Logger Access** - Debugging

---

## 📖 How to Use New Features

### Example: Migrating from User Tokens to API Keys

**Before (user token):**
```bash
# Using personal user token everywhere
curl "https://abs.example.com/api/libraries" \
  -H "Authorization: Bearer user_personal_token_abc123"
```

**After (API key):**
```bash
# Create dedicated API key
curl -X POST "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer admin_token" \
  -d '{"userIdOrUsername": "automation"}'

# Use API key for automation
curl "https://abs.example.com/api/libraries" \
  -H "Authorization: Bearer abs_api_dedicated_key_xyz789"
```

**Benefits:**
- Revoke access without changing password
- Separate keys per integration
- Audit trail of API access
- Fine-grained permissions

---

### Example: Adding Media Sharing

**New capability:**
```javascript
// Create a share link
const share = await fetch('https://abs.example.com/api/share/mediaitem', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    libraryItemId: 'li_abc123',
    expiresAt: Date.now() + (7 * 24 * 60 * 60 * 1000) // 7 days
  })
}).then(r => r.json());

// Share the URL with friends
const shareUrl = `https://abs.example.com/share/${share.slug}`;
console.log(`Share this link: ${shareUrl}`);
```

**No authentication required to access!**

---

### Example: Sending Books to Kindle

**Setup once:**
```bash
# Configure SMTP (admin)
curl -X PATCH "https://abs.example.com/api/emails/settings" \
  -H "Authorization: Bearer admin_token" \
  -d '{
    "host": "smtp.gmail.com",
    "port": 587,
    "user": "your_email@gmail.com",
    "pass": "app_password"
  }'

# Add your Kindle email (user)
curl -X POST "https://abs.example.com/api/me/ereader-devices" \
  -H "Authorization: Bearer user_token" \
  -d '{
    "name": "My Kindle",
    "email": "username@kindle.com"
  }'
```

**Send books anytime:**
```bash
curl -X POST "https://abs.example.com/api/emails/send-ebook-to-device" \
  -H "Authorization: Bearer user_token" \
  -d '{
    "libraryItemId": "li_abc123",
    "deviceName": "My Kindle"
  }'
```

**Auto-converts EPUB → MOBI!**

---

## 🔮 Future Roadmap

### Planned Improvements

1. **OpenAPI/Swagger Specification** - Auto-generated API docs
2. **Interactive API Explorer** - Test endpoints in your browser
3. **Webhook Documentation** - Real-time event notifications
4. **GraphQL API** - Alternative query interface
5. **Rate Limiting Docs** - Usage limits and quotas
6. **SDK Documentation** - Official client libraries

### Community Contributions

Want to help improve the documentation?

- **Report issues** - Found outdated info? Let us know!
- **Submit examples** - Share your integration code
- **Translate docs** - Help international users
- **Add tutorials** - Write guides for common use cases

**Repository:** https://github.com/AlmightyTopher/audiobookshelf-api-docs

---

## 🙏 Acknowledgments

This documentation update was made possible by:

- **Community feedback** - Thank you for reporting gaps!
- **API source code analysis** - Direct inspection of the Audiobookshelf backend
- **Testing and validation** - Verified all endpoints work as documented

---

## 📞 Questions?

- **Issues?** Open a ticket on GitHub
- **Questions?** Check the [Quick Start](#quick-start) guide
- **Need help?** Consult the [Endpoint Matrix](ENDPOINT_MATRIX.md)

**Happy coding! 🎧📚**
