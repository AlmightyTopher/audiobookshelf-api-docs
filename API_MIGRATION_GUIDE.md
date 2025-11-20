# API Migration Guide

## Overview

This guide helps API consumers understand and adopt the newly documented endpoints in the Audiobookshelf API. **Good news: There are no breaking changes!** All additions are backward compatible, so existing integrations will continue to work without modification.

---

## What's New

### Summary of Changes

This update adds documentation for **29 previously undocumented endpoints** across **4 new categories** and **8 existing categories**. All endpoints have been available in recent Audiobookshelf versions but were not documented.

**Impact on Existing Integrations:**
- ✅ No breaking changes
- ✅ Existing endpoints unchanged
- ✅ Existing request/response formats unchanged
- ✅ Existing authentication mechanisms unchanged

**What You Can Do:**
- Adopt new endpoints to add features
- Improve existing features with new capabilities
- Simplify workflows with batch operations

---

## New Capabilities by Use Case

### 🔐 Security & Access Management

#### API Key Management (NEW)

**What it enables:**
- Programmatic creation of API keys
- Key rotation and revocation
- Expiration-based access control
- Audit trail of API key usage

**Before:**
```bash
# Had to manually create keys via UI
```

**After:**
```bash
# Create API key programmatically
curl -X POST "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "CI/CD Pipeline",
    "expiresAt": 1735689600000
  }'

# Response includes key (only shown once!)
{
  "apiKey": {
    "id": "apk_abc123",
    "name": "CI/CD Pipeline",
    "key": "sk_xyz789...",  // Save this!
    "expiresAt": 1735689600000,
    "isActive": true
  }
}
```

**Migration Tips:**
1. Create dedicated API keys for each integration
2. Set expiration dates for temporary access
3. Use descriptive names for easier management
4. Store keys securely (password manager, secrets vault)
5. Revoke keys immediately if compromised

**Best Practices:**
- ✅ One key per service/integration
- ✅ Set expiration for temporary access
- ✅ Use meaningful names
- ✅ Revoke unused keys
- ❌ Don't share keys between services
- ❌ Don't commit keys to version control

---

### 🔗 Content Sharing

#### Media Sharing (NEW)

**What it enables:**
- Share audiobooks/podcasts with friends
- Create public links without requiring accounts
- Set expiration dates on shares
- Track playback progress on shared items

**Before:**
```bash
# No programmatic way to create share links
```

**After:**
```bash
# Create share link
curl -X POST "https://abs.example.com/api/share/mediaitem" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_book123",
    "expiresAt": 1735689600000
  }'

# Response
{
  "mediaItemShare": {
    "id": "shr_abc123",
    "slug": "happy-narwhal-42",  // Use this in URL
    "expiresAt": 1735689600000
  }
}

# Share URL is: https://abs.example.com/share/happy-narwhal-42
```

**Public endpoints (no auth required):**
```bash
# Get share details
GET /api/share/happy-narwhal-42

# Stream audio
GET /api/share/happy-narwhal-42/track/0

# Get cover
GET /api/share/happy-narwhal-42/cover

# Download
GET /api/share/happy-narwhal-42/download
```

**Use Cases:**
1. **Book clubs:** Share current book with members
2. **Recommendations:** Send friends sample chapters
3. **Family sharing:** Temporary access for family members
4. **Time-limited access:** Set expiration for borrowed content

**Security Considerations:**
- Slugs are non-guessable (safe from enumeration)
- Set expirations for time-limited access
- Revoke shares via DELETE endpoint
- Monitor active shares via admin dashboard

---

### 📧 Email Integration

#### Email & eReader Support (NEW)

**What it enables:**
- Send ebooks to Kindle/eReaders
- Configure SMTP for notifications
- Manage eReader devices per user
- Automatic format conversion

**Before:**
```bash
# Manual email configuration only
```

**After:**
```bash
# 1. Configure SMTP settings (admin)
curl -X PATCH "https://abs.example.com/api/emails/settings" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "host": "smtp.gmail.com",
    "port": 587,
    "secure": false,
    "user": "library@example.com",
    "pass": "app-password",
    "fromAddress": "noreply@example.com"
  }'

# 2. Test email configuration
curl -X POST "https://abs.example.com/api/emails/test" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# 3. Configure eReader devices (server-wide)
curl -X POST "https://abs.example.com/api/emails/ereader-devices" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "ereaderDevices": [
      {
        "name": "Office Kindle",
        "email": "office_kindle@kindle.com",
        "availabilityOption": "adminOrUp",
        "users": ["user1", "user2"]
      }
    ]
  }'

# 4. Send book to device
curl -X POST "https://abs.example.com/api/emails/send-ebook-to-device" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemId": "li_book123",
    "deviceName": "Office Kindle"
  }'
```

**Personal eReader devices:**
```bash
# Users can manage their own devices
curl -X POST "https://abs.example.com/api/me/ereader-devices" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "ereaderDevices": [
      {
        "name": "My Kindle",
        "email": "mykindle_xyz@kindle.com"
      }
    ]
  }'
```

**Format Conversion:**
- EPUB → MOBI (for Kindle)
- Automatic detection based on device
- No manual conversion needed

**Troubleshooting:**
1. Test SMTP config with `/api/emails/test`
2. Verify device email is correct
3. Check Kindle "Approved Email Addresses" settings
4. Confirm file size within email limits (typically 25MB)

---

### 📊 Analytics & Statistics

#### Server Statistics (NEW)

**What it enables:**
- Year-over-year comparisons
- Server health monitoring
- Usage trend analysis
- Admin dashboards

**Before:**
```bash
# Only library and user stats available
```

**After:**
```bash
# Get server-wide statistics
curl "https://abs.example.com/api/stats/server" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# Response
{
  "totalItems": 1234,
  "totalBooks": 1100,
  "totalPodcasts": 134,
  "totalAuthors": 567,
  "totalDuration": 1234567.89,
  "totalListeningTime": 456789.12,
  "serverVersion": "2.8.0",
  "serverUptime": 1234567
}

# Get year-specific statistics
curl "https://abs.example.com/api/stats/year/2024" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# Response includes
{
  "mostActiveUsers": [...],
  "topGenres": [...],
  "topAuthors": [...],
  "recentlyAdded": [...]
}
```

**Personal year statistics:**
```bash
# Non-admin users can get their own stats
curl "https://abs.example.com/api/me/stats/year/2024" \
  -H "Authorization: Bearer $TOKEN"
```

**Three-tier statistics:**
1. **Server** (`/api/stats/server`) - Global metrics (admin-only)
2. **Library** (`/api/libraries/:id/stats`) - Per-library metrics
3. **User** (`/api/me/stats/year/:year`) - Personal metrics

**Dashboard Integration:**
```javascript
// Example: Build year-in-review
async function yearInReview(year) {
  const stats = await fetch(`/api/me/stats/year/${year}`, {
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(r => r.json());

  return {
    totalHours: stats.totalListeningTime / 3600,
    topGenre: stats.topGenres[0],
    topAuthor: stats.topAuthors[0],
    booksCompleted: stats.recentlyFinished.length
  };
}
```

---

### 🎵 Library Management Enhancements

#### Narrator Management (NEW)

**What it enables:**
- List all narrators with book counts
- Rename narrators across library
- Remove narrator from all books
- Fix typos and standardize names

**Before:**
```bash
# Had to edit each book individually
```

**After:**
```bash
# 1. List narrators
curl "https://abs.example.com/api/libraries/lib_123/narrators" \
  -H "Authorization: Bearer $TOKEN"

# Response
{
  "narrators": [
    { "name": "Sam Tsoutsouvas", "numBooks": 15 },
    { "name": "George Guidall", "numBooks": 8 }
  ]
}

# 2. Rename narrator (fix typo)
curl -X PATCH "https://abs.example.com/api/libraries/lib_123/narrators/Sam%20Tsoutsouvas" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Samuel Tsoutsouvas"}'

# Response
{
  "updated": true,
  "numBooksUpdated": 15
}

# 3. Remove narrator
curl -X DELETE "https://abs.example.com/api/libraries/lib_123/narrators/George%20Guidall" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# Response
{
  "numBooksUpdated": 8
}
```

**URL Encoding:**
```javascript
// Narrator names can have spaces/special chars
const narratorName = "Sam Tsoutsouvas";
const encoded = encodeURIComponent(narratorName);
// Result: "Sam%20Tsoutsouvas"
```

---

#### Series Deep-Linking (NEW)

**What it enables:**
- Direct access to specific series
- Bookmarkable series pages
- Include progress data

**Before:**
```bash
# Could only list all series
GET /api/libraries/lib_123/series
```

**After:**
```bash
# Get specific series with books
curl "https://abs.example.com/api/libraries/lib_123/series/ser_456" \
  -H "Authorization: Bearer $TOKEN"

# With progress data
curl "https://abs.example.com/api/libraries/lib_123/series/ser_456?include=progress" \
  -H "Authorization: Bearer $TOKEN"
```

---

#### OPML Export (NEW)

**What it enables:**
- Backup podcast subscriptions
- Export to other podcast apps
- Podcast library migration

**Before:**
```bash
# No way to export podcast feeds
```

**After:**
```bash
# Export OPML file
curl "https://abs.example.com/api/libraries/lib_podcasts/opml" \
  -H "Authorization: Bearer $TOKEN" \
  -o podcasts.opml

# Result: XML file with all podcast feeds
```

**Use Cases:**
1. Backup podcast subscriptions
2. Migrate to another podcast manager
3. Share podcast recommendations
4. Restore after server migration

---

#### Bulk Download (NEW)

**What it enables:**
- Download multiple books as ZIP
- Batch downloads for offline use
- Archive creation

**Before:**
```bash
# Had to download each item individually
```

**After:**
```bash
# Download multiple items as ZIP
curl "https://abs.example.com/api/libraries/lib_123/download?libraryItemIds=li_1,li_2,li_3" \
  -H "Authorization: Bearer $TOKEN" \
  -o books.zip
```

**URL Length Consideration:**
```bash
# For many items, use POST with body instead
# (if supported in future version)
```

---

### 🔧 System Administration

#### Custom Metadata Providers (NEW)

**What it enables:**
- Integrate private metadata APIs
- Support specialized catalogs
- Regional metadata sources

**Before:**
```bash
# Only built-in providers available
```

**After:**
```bash
# 1. Create custom provider
curl -X POST "https://abs.example.com/api/custom-metadata-providers" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Internal Catalog",
    "url": "https://metadata.internal.com/search",
    "mediaType": "book",
    "authHeaderValue": "Bearer internal-token-123"
  }'

# 2. List all providers
curl "https://abs.example.com/api/custom-metadata-providers" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# 3. Delete provider
curl -X DELETE "https://abs.example.com/api/custom-metadata-providers/cmp_123" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

**Provider API Requirements:**
- Must return expected metadata format
- Support search by title/author
- Optional: Support lookup by ISBN/ASIN

---

#### Authentication Settings (NEW)

**What it enables:**
- Configure OpenID Connect via API
- Automate SSO setup
- Manage authentication flow

**Before:**
```bash
# Manual configuration via UI only
```

**After:**
```bash
# Get current auth settings
curl "https://abs.example.com/api/auth-settings" \
  -H "Authorization: Bearer $TOKEN"

# Update OpenID configuration (admin)
curl -X PATCH "https://abs.example.com/api/auth-settings" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "authOpenIDIssuerURL": "https://auth.example.com",
    "authOpenIDClientID": "audiobookshelf-client",
    "authOpenIDClientSecret": "secret-123",
    "authOpenIDButtonText": "Login with Company SSO",
    "authOpenIDAutoLaunch": true
  }'
```

**Infrastructure as Code:**
```yaml
# Example: Terraform
resource "audiobookshelf_auth_settings" "sso" {
  issuer_url = var.oidc_issuer
  client_id  = var.oidc_client_id
  client_secret = var.oidc_client_secret
  auto_launch = true
}
```

---

#### Background Task Monitoring (NEW)

**What it enables:**
- Monitor long-running operations
- Display progress indicators
- Debug stuck tasks

**Before:**
```bash
# No visibility into background tasks
```

**After:**
```bash
# Get all active and recent tasks
curl "https://abs.example.com/api/tasks" \
  -H "Authorization: Bearer $TOKEN"

# Response
{
  "tasks": [
    {
      "id": "task_123",
      "type": "encode-m4b",
      "status": "active",
      "data": {
        "libraryItemId": "li_book123",
        "libraryItemTitle": "Book Title"
      },
      "startedAt": 1700000000000,
      "finishedAt": null
    }
  ]
}
```

**UI Integration:**
```javascript
// Poll for task updates
async function monitorTask(taskId) {
  const interval = setInterval(async () => {
    const tasks = await fetch('/api/tasks').then(r => r.json());
    const task = tasks.tasks.find(t => t.id === taskId);

    if (task.status === 'completed') {
      clearInterval(interval);
      showSuccess('Task completed!');
    } else if (task.status === 'failed') {
      clearInterval(interval);
      showError('Task failed');
    }
  }, 5000);
}
```

---

## Batch Operations Enhancements

### Batch Scan (NEW)

**What it enables:**
- Scan multiple items efficiently
- Refresh specific items after changes
- Automation-friendly

**Before:**
```bash
# Could batch delete, update, get, quickmatch
# But NOT batch scan
```

**After:**
```bash
# Scan multiple items
curl -X POST "https://abs.example.com/api/items/batch/scan" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "libraryItemIds": [
      "li_item1",
      "li_item2",
      "li_item3"
    ]
  }'
```

**Complete batch operations:**
- ✅ Batch delete
- ✅ Batch update
- ✅ Batch get
- ✅ Batch quickmatch
- ✅ Batch scan (NEW)

---

### Batch Delete Sessions (NEW)

**What it enables:**
- Clean up listening history
- Privacy management
- Bulk session management

**Before:**
```bash
# Delete one session at a time
```

**After:**
```bash
# Delete multiple sessions
curl -X POST "https://abs.example.com/api/sessions/batch/delete" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "sessionIds": [
      "play_session1",
      "play_session2",
      "play_session3"
    ]
  }'

# Response
{
  "deleted": 3
}
```

---

## Implementation Checklist

### Phase 1: Immediate Adoption (No Code Changes)

- [ ] Review newly documented endpoints
- [ ] Identify beneficial features for your use case
- [ ] Update internal documentation
- [ ] Inform team members

### Phase 2: Feature Additions (Optional)

#### Security Improvements
- [ ] Migrate to API key authentication
- [ ] Implement key rotation policy
- [ ] Set expiration dates on keys
- [ ] Create dedicated keys per service

#### Sharing Features
- [ ] Add "Share" button to UI
- [ ] Implement expiration management
- [ ] Create share dashboard
- [ ] Add share analytics

#### Email Integration
- [ ] Configure SMTP settings
- [ ] Set up eReader devices
- [ ] Add "Send to Kindle" feature
- [ ] Test email delivery

#### Analytics Enhancement
- [ ] Build admin dashboard with server stats
- [ ] Implement year-in-review feature
- [ ] Create usage reports
- [ ] Monitor trends

### Phase 3: Workflow Optimization

#### Library Management
- [ ] Add narrator management UI
- [ ] Implement series deep-linking
- [ ] Add OPML import/export
- [ ] Create bulk download feature

#### System Administration
- [ ] Automate auth configuration
- [ ] Set up custom metadata providers
- [ ] Implement task monitoring
- [ ] Create admin tools

---

## Code Examples

### API Client Integration

```javascript
// Example: Add share functionality to existing client

class AudiobookshelfClient {
  // Existing methods...

  // NEW: Share management
  async createShare(libraryItemId, expiresAt = null) {
    return this.post('/api/share/mediaitem', {
      libraryItemId,
      expiresAt
    });
  }

  async deleteShare(shareId) {
    return this.delete(`/api/share/mediaitem/${shareId}`);
  }

  async getShare(slug) {
    // No auth required for public endpoint
    return fetch(`${this.baseUrl}/api/share/${slug}`)
      .then(r => r.json());
  }

  // NEW: API key management
  async createApiKey(name, expiresAt = null) {
    return this.post('/api/api-keys', { name, expiresAt });
  }

  async listApiKeys() {
    return this.get('/api/api-keys');
  }

  async deleteApiKey(keyId) {
    return this.delete(`/api/api-keys/${keyId}`);
  }

  // NEW: Email integration
  async sendToKindle(libraryItemId, deviceName) {
    return this.post('/api/emails/send-ebook-to-device', {
      libraryItemId,
      deviceName
    });
  }

  // NEW: Statistics
  async getServerStats() {
    return this.get('/api/stats/server');
  }

  async getYearStats(year) {
    return this.get(`/api/me/stats/year/${year}`);
  }
}
```

### React Component Example

```javascript
// Example: Share button component

function ShareButton({ libraryItemId }) {
  const [shareLink, setShareLink] = useState(null);
  const [loading, setLoading] = useState(false);

  async function createShare() {
    setLoading(true);
    try {
      const response = await client.createShare(libraryItemId);
      const url = `${window.location.origin}/share/${response.mediaItemShare.slug}`;
      setShareLink(url);

      // Copy to clipboard
      navigator.clipboard.writeText(url);
      toast.success('Share link copied!');
    } catch (error) {
      toast.error('Failed to create share link');
    } finally {
      setLoading(false);
    }
  }

  return (
    <button onClick={createShare} disabled={loading}>
      {loading ? 'Creating...' : 'Share'}
    </button>
  );
}
```

---

## Testing Your Integration

### 1. Verify Endpoint Availability

```bash
# Test each new endpoint you plan to use
curl -I "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer $TOKEN"

# Should return 200 if endpoint exists
```

### 2. Test with Sample Data

```bash
# Create test API key
curl -X POST "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Key"}'

# Verify creation
curl "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# Clean up
curl -X DELETE "https://abs.example.com/api/api-keys/<test-key-id>" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

### 3. Error Handling

```bash
# Test without authentication
curl "https://abs.example.com/api/api-keys"
# Should return 401

# Test with non-admin user
curl "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer $NON_ADMIN_TOKEN"
# Should return 403

# Test with invalid ID
curl "https://abs.example.com/api/api-keys/invalid-id" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
# Should return 404
```

---

## Troubleshooting

### Common Issues

#### 1. **401 Unauthorized**
```
Error: Unauthorized
```
**Solutions:**
- Verify API token is valid
- Check token hasn't expired
- Ensure Authorization header is properly formatted

#### 2. **403 Forbidden**
```
Error: An admin user is required
```
**Solutions:**
- Verify user has admin privileges
- Use admin token for admin-only endpoints
- Check user permissions in user settings

#### 3. **404 Not Found**
```
Error: Resource not found
```
**Solutions:**
- Verify endpoint path is correct
- Check if feature is available in your Audiobookshelf version
- Ensure resource ID exists

#### 4. **Share Link Not Working**
```
Error: Share not found or expired
```
**Solutions:**
- Check if share has expired
- Verify slug is correct
- Confirm share wasn't deleted

#### 5. **Email Not Sending**
```
Error: Failed to send email
```
**Solutions:**
- Test SMTP configuration with `/api/emails/test`
- Verify SMTP credentials
- Check server logs for detailed error
- Confirm port and TLS settings

---

## Version Compatibility

### Minimum Version Requirements

**These endpoints require:**
- Audiobookshelf v2.8.0 or later (estimated)

**To check your version:**
```bash
curl "https://abs.example.com/api/stats/server" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  | jq '.serverVersion'
```

### Feature Detection

```javascript
// Check if endpoint exists before using
async function hasEndpoint(path) {
  try {
    const response = await fetch(
      `${baseUrl}${path}`,
      { method: 'OPTIONS' }
    );
    return response.ok;
  } catch {
    return false;
  }
}

// Use feature detection
if (await hasEndpoint('/api/api-keys')) {
  // Use API key features
} else {
  // Fall back to manual key management
}
```

---

## Support & Resources

### Documentation
- Full API docs: https://api.audiobookshelf.org
- Schema reference: See `_schemas.md`
- Changelog: See `CHANGELOG_DRAFT.md`

### Getting Help
- GitHub issues: https://github.com/advplyr/audiobookshelf/issues
- Discord community: https://discord.gg/audiobookshelf
- Documentation repo: https://github.com/advplyr/audiobookshelf-api-docs

### Reporting Issues
If you find any issues with the documentation:
1. Check existing GitHub issues
2. Verify against actual API behavior
3. Report with curl example and expected vs actual behavior

---

## Summary

**Remember:**
- ✅ No breaking changes - safe to adopt at your own pace
- ✅ All endpoints are backward compatible
- ✅ Existing integrations continue working
- ✅ New features are opt-in

**Recommended adoption order:**
1. **Security:** API key management
2. **Features:** Sharing and email integration
3. **Analytics:** Statistics and monitoring
4. **Administration:** Custom providers and auth settings

**Questions?**
- Review the full documentation
- Check code examples above
- Reach out via GitHub or Discord

Happy coding! 🚀
