# Share

## Create a Media Item Share

```shell
curl -X POST "https://abs.example.com/api/share/mediaitem" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"libraryItemId": "li_8gch9ve09orgn4fdz8", "expiresAt": null}'
```

> The above command returns JSON structured like this:

```json
{
  "mediaItemShare": {
    "id": "shr_1234567890abcdef",
    "slug": "happy-narwhal-42",
    "userId": "root",
    "libraryItemId": "li_8gch9ve09orgn4fdz8",
    "mediaItemId": "li_8gch9ve09orgn4fdz8",
    "mediaItemType": "book",
    "expiresAt": null,
    "createdAt": 1234567890
  }
}
```

This endpoint creates a shareable link for a media item (book or podcast episode).

### HTTP Request

`POST http://abs.example.com/api/share/mediaitem`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`libraryItemId` | String | The ID of the library item to share.
`episodeId` | String | Optional. For podcasts, the ID of the specific episode to share.
`expiresAt` | Integer or null | Optional. Timestamp when the share link expires. If `null`, the link never expires.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid request parameters. |
403 | Forbidden | User does not have permission to share this item. |
404 | Not Found | Library item not found. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`mediaItemShare` | [Media Item Share](#media-item-share) Object | The created share object.

<aside class="notice">
The <code>slug</code> is a human-readable identifier used in the share URL: <code>https://abs.example.com/share/:slug</code>
</aside>


## Delete a Media Item Share

```shell
curl -X DELETE "https://abs.example.com/api/share/mediaitem/shr_1234567890abcdef" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

This endpoint deletes a media item share, revoking access to the shared link.

### HTTP Request

`DELETE http://abs.example.com/api/share/mediaitem/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the media item share to delete.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
403 | Forbidden | User does not have permission to delete this share.
404 | Not Found | Share not found.


## Get a Media Item Share (Public)

```shell
curl "https://abs.example.com/api/share/happy-narwhal-42"
```

> The above command returns JSON structured like this:

```json
{
  "id": "shr_1234567890abcdef",
  "slug": "happy-narwhal-42",
  "mediaItem": {
    "id": "li_8gch9ve09orgn4fdz8",
    "metadata": {
      "title": "Wizards First Rule",
      "author": "Terry Goodkind",
      "description": "The masterpiece that started Terry Goodkind's New York Times bestselling epic Sword of Truth...",
      "publishedYear": "2008",
      "publisher": "Brilliance Audio",
      "coverPath": "/share/happy-narwhal-42/cover"
    },
    "mediaType": "book",
    "duration": 33854.905,
    "numTracks": 37
  },
  "expiresAt": null,
  "createdAt": 1234567890
}
```

This endpoint retrieves information about a shared media item. This endpoint is **public** and does not require authentication.

### HTTP Request

`GET http://abs.example.com/api/share/<Slug>`

### URL Parameters

Parameter | Description
--------- | -----------
Slug | The slug of the share link.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
404 | Not Found | Share not found or expired.


## Get a Media Item Share Audio Track (Public)

```shell
curl "https://abs.example.com/api/share/happy-narwhal-42/track/0"
```

This endpoint streams an audio track from a shared media item. This endpoint is **public** and does not require authentication.

### HTTP Request

`GET http://abs.example.com/api/share/<Slug>/track/<Index>`

### URL Parameters

Parameter | Description
--------- | -----------
Slug | The slug of the share link.
Index | The zero-based index of the audio track.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Audio file stream
404 | Not Found | Share not found, expired, or track index invalid.


## Get a Media Item Share Cover (Public)

```shell
curl "https://abs.example.com/api/share/happy-narwhal-42/cover"
```

This endpoint retrieves the cover image for a shared media item. This endpoint is **public** and does not require authentication.

### HTTP Request

`GET http://abs.example.com/api/share/<Slug>/cover`

### URL Parameters

Parameter | Description
--------- | -----------
Slug | The slug of the share link.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Cover image
404 | Not Found | Share not found or expired.


## Download a Media Item Share (Public)

```shell
curl "https://abs.example.com/api/share/happy-narwhal-42/download"
```

This endpoint downloads the entire shared media item as a single file. This endpoint is **public** and does not require authentication.

### HTTP Request

`GET http://abs.example.com/api/share/<Slug>/download`

### URL Parameters

Parameter | Description
--------- | -----------
Slug | The slug of the share link.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Media item file download
404 | Not Found | Share not found or expired.


## Update Media Item Share Progress (Public)

```shell
curl -X PATCH "https://abs.example.com/api/share/happy-narwhal-42/progress" \
  -H "Content-Type: application/json" \
  -d '{"currentTime": 632.5, "duration": 1454.18, "progress": 0.435}'
```

This endpoint updates the playback progress for a shared media item. This endpoint is **public** and does not require authentication. Progress is stored locally in the client.

### HTTP Request

`PATCH http://abs.example.com/api/share/<Slug>/progress`

### URL Parameters

Parameter | Description
--------- | -----------
Slug | The slug of the share link.

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`currentTime` | Float | Current playback time in seconds.
`duration` | Float | Total duration in seconds.
`progress` | Float | Progress as a decimal (0.0 to 1.0).

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
404 | Not Found | Share not found or expired.
