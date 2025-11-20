# Misc

## Upload Files

```shell
curl -X POST "https://abs.example.com/api/upload" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -F title="Wizard's First Rule" \
  -F author="Terry Goodkind" \
  -F series="Sword of Truth" \
  -F library="lib_c1u6t4p45c35rf0nzd" \
  -F folder="fol_bev1zuxhb0j0s1wehr" \
  -F 0=@"Terry Goodkind - SOT Bk01 - Wizards First Rule 01.mp3" \
  -F 1=@"Terry Goodkind - SOT Bk01 - Wizards First Rule 02.mp3" \
  -F 2=@cover.jpg
```

This endpoint uploads library item files to the server.

### HTTP Request

`POST http://abs.example.com/api/upload`

### Form Parameters

Parameter | Type | Description
--------- | ---- | -----------
`title` | String | The library item's title.
`author` | String | Optionally, the library item's author.
`series` | String | Optionally, the library item's series.
`library` | String | The ID of the library to put the item in.
`folder` | String | The ID of the folder to put the item in.

The files will be put in a directory at `<folderDir>/<author>/<series>/<title>`.

The form keys for the files can be anything as they are ignored.

The following file types are supported:

* `.png`
* `.jpg`
* `.jpeg`
* `.webp`
* `.m4b`
* `.mp3`
* `.m4a`
* `.flac`
* `.opus`
* `.ogg`
* `.oga`
* `.mp4`
* `.aac`
* `.wma`
* `.aiff`
* `.wav`
* `.webm`
* `.webma`
* `.epub`
* `.pdf`
* `.mobi`
* `.azw3`
* `.cbr`
* `.cbz`
* `.nfo`
* `.txt`
* `.opf`
* `.abs`

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
400 | Bad Request | No files were provided.
403 | Forbidden | A user with upload permissions is required.
404 | Not Found | No library with the given ID exists, or no folder with the given ID exists in the library.
500 | Internal Server Error | No files were provided, or the upload directory already exists.


## Update Server Settings

```shell
curl -X PATCH "https://abs.example.com/api/settings" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"scannerFindCovers": false}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "serverSettings": {
    "id": "server-settings",
    "scannerFindCovers": false,
    "scannerCoverProvider": "google",
    "scannerParseSubtitle": false,
    "scannerPreferMatchedMetadata": false,
    "scannerDisableWatcher": true,
    "storeCoverWithItem": false,
    "storeMetadataWithItem": false,
    "metadataFileFormat": "json",
    "rateLimitLoginRequests": 10,
    "rateLimitLoginWindow": 600000,
    "backupSchedule": "30 1 * * *",
    "backupsToKeep": 2,
    "maxBackupSize": 1,
    "loggerDailyLogsToKeep": 7,
    "loggerScannerLogsToKeep": 2,
    "homeBookshelfView": 1,
    "bookshelfView": 1,
    "sortingIgnorePrefix": false,
    "sortingPrefixes": [
      "the",
      "a"
    ],
    "chromecastEnabled": false,
    "dateFormat": "MM/dd/yyyy",
    "timeFormat": "HH:mm",
    "language": "en-us",
    "logLevel": 2,
    "version": "2.2.5"
  }
}
```

This endpoint updates the server's settings.

### HTTP Request

`PATCH http://abs.example.com/api/settings`

### Parameters

Provide a [Server Settings](#server-settings) object with the key-value pairs to update.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to update server settings. |
500 | Internal Server Error | Invalid server settings update object. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the server settings were updated successfully.
`serverSettings` | [Server Settings](#server-settings) Object | The updated server settings.


## Get Authorized User and Server Information

```shell
curl -X POST "https://abs.example.com/api/authorize" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "user": {
    "id": "root",
    "username": "root",
    "type": "root",
    "token": "exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY",
    "mediaProgress": [
      {
        "id": "li_bufnnmp4y5o2gbbxfm-ep_lh6ko39pumnrma3dhv",
        "libraryItemId": "li_bufnnmp4y5o2gbbxfm",
        "episodeId": "ep_lh6ko39pumnrma3dhv",
        "duration": 1454.18449,
        "progress": 0.434998929881311,
        "currentTime": 632.568697,
        "isFinished": false,
        "hideFromContinueListening": false,
        "lastUpdate": 1668586015691,
        "startedAt": 1668120083771,
        "finishedAt": null
      }
    ],
    "seriesHideFromContinueListening": [],
    "bookmarks": [],
    "isActive": true,
    "isLocked": false,
    "lastSeen": 1669010786013,
    "createdAt": 1666543632566,
    "permissions": {
      "download": true,
      "update": true,
      "delete": true,
      "upload": true,
      "accessAllLibraries": true,
      "accessAllTags": true,
      "accessExplicitContent": true
    },
    "librariesAccessible": [],
    "itemTagsAccessible": []
  },
  "userDefaultLibraryId": "lib_c1u6t4p45c35rf0nzd",
  "serverSettings": {
    "id": "server-settings",
    "scannerFindCovers": false,
    "scannerCoverProvider": "audible",
    "scannerParseSubtitle": false,
    "scannerPreferMatchedMetadata": false,
    "scannerDisableWatcher": true,
    "storeCoverWithItem": false,
    "storeMetadataWithItem": false,
    "metadataFileFormat": "json",
    "rateLimitLoginRequests": 10,
    "rateLimitLoginWindow": 600000,
    "backupSchedule": "30 1 * * *",
    "backupsToKeep": 2,
    "maxBackupSize": 1,
    "loggerDailyLogsToKeep": 7,
    "loggerScannerLogsToKeep": 2,
    "homeBookshelfView": 1,
    "bookshelfView": 1,
    "sortingIgnorePrefix": false,
    "sortingPrefixes": [
      "the",
      "a"
    ],
    "chromecastEnabled": false,
    "dateFormat": "MM/dd/yyyy",
    "timeFormat": "HH:mm",
    "language": "en-us",
    "logLevel": 2,
    "version": "2.2.5"
  },
  "Source": "docker"
}
```

This endpoint retrieves information about the authorized user and the server. Used for logging into a client if an API token was persisted. Returns the same payload as `/login` ([Login](#login)).

### HTTP Request

`POST http://abs.example.com/api/authorize`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
401 | Unauthorized | No authorization was provided. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`user` | [User](#user) Object | The authenticated user.
`userDefaultLibraryId` | String | The ID of the first library in the list the user has access to.
`serverSettings` | [Server Settings](#server-settings) Object | The server's settings.
`Source` | String | The server's installation source.

## Get All Tags

```shell
curl "https://abs.example.com/api/tags" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "tags": [
    "Favorite"
  ]
}
```

This endpoint retrieves all tags assigned to library items.

### HTTP Request

`GET http://abs.example.com/api/tags`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See Below
404 | Not Found | An admin user is required to get all tags. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`tags` | Array of String | The requested tags.


## Rename a Tag

```shell
curl -X POST "https://abs.example.com/api/tags/rename" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"tag": "Favorite", "newTag": "The Best"}'
```

> The above command returns JSON structured like this:

```json
{
  "tagMerged": false,
  "numItemsUpdated": 1
}
```

This endpoint renames an existing tag.

### HTTP Request

`POST http://abs.example.com/api/tags/rename`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`tag` | String | The current name of the tag.
`newTag` | String | The new name for the tag.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See Below
400 | Bad Request | `tag` and `newTag` are required parameters. |
404 | Not Found | An admin user is required to rename tags. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`tagMerged` | Boolean | Whether the renamed tag was merged into another tag.
`numItemsUpdated` | Integer | The number of library items that had their tags changed.


## Delete a Tag

```shell
curl -X DELETE "https://abs.example.com/api/tags/VGhlIEJlc3Q%3D" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "numItemsUpdated": 1
}
```

This endpoint deletes a tag, removing it from all library items.

### HTTP Request

`DELETE http://abs.example.com/api/tags/<Tag>`

### URL Parameters

Parameter | Description
--------- | -----------
Tag | The name of the tag to delete, Base64 and URL encoded.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See Below
404 | Not Found | An admin user is required to delete tags. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`numItemsUpdated` | Integer | The number of library items that had their tags changed.


## Get All Genres

```shell
curl "https://abs.example.com/api/genres" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "genres": [
    "Fantasy"
  ]
}
```

This endpoint retrieves all genres assigned to library items.

### HTTP Request

`GET http://abs.example.com/api/genres`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See Below
404 | Not Found | An admin user is required to get all genres. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`genres` | Array of String | The requested genres.


## Rename a Genre

```shell
curl -X POST "https://abs.example.com/api/genres/rename" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"genre": "Fantasy", "newGenre": "Magic"}'
```

> The above command returns JSON structured like this:

```json
{
  "genreMerged": false,
  "numItemsUpdated": 1
}
```

This endpoint renames an existing genre.

### HTTP Request

`POST http://abs.example.com/api/genres/rename`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`genre` | String | The current name of the genre.
`newGenre` | String | The new name for the genre.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See Below
400 | Bad Request | `genre` and `newGenre` are required parameters. |
404 | Not Found | An admin user is required to rename genres. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`genreMerged` | Boolean | Whether the renamed genre was merged into another genre.
`numItemsUpdated` | Integer | The number of library items that had their genres changed.


## Delete a Genre

```shell
curl -X DELETE "https://abs.example.com/api/genres/TWFnaWM%3D" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "numItemsUpdated": 1
}
```

This endpoint deletes a genre, removing it from all library items.

### HTTP Request

`DELETE http://abs.example.com/api/genres/<Genre>`

### URL Parameters

Parameter | Description
--------- | -----------
Genre | The name of the genre to delete, Base64 and URL encoded.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See Below
404 | Not Found | An admin user is required to delete genres. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`numItemsUpdated` | Integer | The number of library items that had their genres changed.


## Validate a Cron Expression

```shell
curl -X POST "https://abs.example.com/api/validate-cron" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"expression": "30 1 * * *"}'
```

This endpoint validates a given [cron expression](https://en.wikipedia.org/wiki/Cron#CRON_expression).

### HTTP Request

`POST http://abs.example.com/api/validate-cron`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`expression` | String | The cron expression to validate.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
400 | Bad Request | The `expression` parameter is required, or the `expression` is invalid.


## Get Auth Settings

```shell
curl "https://abs.example.com/api/auth-settings" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "authOpenIDIssuerURL": null,
  "authOpenIDAuthorizationURL": null,
  "authOpenIDTokenURL": null,
  "authOpenIDUserInfoURL": null,
  "authOpenIDJwksURL": null,
  "authOpenIDLogoutURL": null,
  "authOpenIDClientID": null,
  "authOpenIDClientSecret": null,
  "authOpenIDButtonText": "Login with OpenID",
  "authOpenIDAutoLaunch": false,
  "authOpenIDAutoRegister": false,
  "authOpenIDMatchExistingBy": null
}
```

This endpoint retrieves the server's authentication settings, including OpenID configuration.

### HTTP Request

`GET http://abs.example.com/api/auth-settings`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`authOpenIDIssuerURL` | String or null | OpenID issuer URL.
`authOpenIDAuthorizationURL` | String or null | OpenID authorization endpoint URL.
`authOpenIDTokenURL` | String or null | OpenID token endpoint URL.
`authOpenIDUserInfoURL` | String or null | OpenID user info endpoint URL.
`authOpenIDJwksURL` | String or null | OpenID JWKS endpoint URL.
`authOpenIDLogoutURL` | String or null | OpenID logout URL.
`authOpenIDClientID` | String or null | OpenID client ID.
`authOpenIDClientSecret` | String or null | OpenID client secret (redacted for non-admin users).
`authOpenIDButtonText` | String | Text to display on the OpenID login button.
`authOpenIDAutoLaunch` | Boolean | Whether to automatically redirect to OpenID login.
`authOpenIDAutoRegister` | Boolean | Whether to automatically register new users from OpenID.
`authOpenIDMatchExistingBy` | String or null | Field to match existing users by (e.g., "email").


## Update Auth Settings

```shell
curl -X PATCH "https://abs.example.com/api/auth-settings" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"authOpenIDButtonText": "Login with SSO", "authOpenIDAutoLaunch": true}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "settings": {
    "authOpenIDButtonText": "Login with SSO",
    "authOpenIDAutoLaunch": true
  }
}
```

This endpoint updates the server's authentication settings.

### HTTP Request

`PATCH http://abs.example.com/api/auth-settings`

### Parameters

Provide any authentication setting keys to update with their new values.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid settings. |
403 | Forbidden | An admin user is required to update auth settings. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the settings were updated successfully.
`settings` | Object | The updated settings.


## Update Sorting Prefixes

```shell
curl -X PATCH "https://abs.example.com/api/sorting-prefixes" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"sortingPrefixes": ["the", "a", "an"]}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "sortingPrefixes": ["the", "a", "an"]
}
```

This endpoint updates the list of prefixes to ignore when sorting titles.

### HTTP Request

`PATCH http://abs.example.com/api/sorting-prefixes`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`sortingPrefixes` | Array of String | List of prefixes to ignore when sorting (e.g., "the", "a", "an").

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid prefixes. |
403 | Forbidden | An admin user is required to update sorting prefixes. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the prefixes were updated successfully.
`sortingPrefixes` | Array of String | The updated sorting prefixes.


## Update Watched Path

```shell
curl -X POST "https://abs.example.com/api/watcher/update" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"libraryId": "lib_c1u6t4p45c35rf0nzd"}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "message": "Watcher updated for library"
}
```

This endpoint updates the file watcher for a library's folders.

### HTTP Request

`POST http://abs.example.com/api/watcher/update`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`libraryId` | String | The ID of the library to update the watcher for.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid library ID. |
403 | Forbidden | An admin user is required to update watchers. |
404 | Not Found | Library not found. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the watcher was updated successfully.
`message` | String | Success message.


## Get Logger Data

```shell
curl "https://abs.example.com/api/logger-data" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "currentDailyLog": {
    "id": "daily-2024-01-15",
    "datestamp": "2024-01-15",
    "logs": [
      {
        "timestamp": 1234567890,
        "level": "info",
        "message": "Server started",
        "metadata": {}
      }
    ]
  },
  "dailyLogFiles": [
    "daily-2024-01-15.txt",
    "daily-2024-01-14.txt"
  ]
}
```

This endpoint retrieves current logger data and log file information.

### HTTP Request

`GET http://abs.example.com/api/logger-data`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to view logger data. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`currentDailyLog` | Object | The current day's log entries.
`dailyLogFiles` | Array of String | List of available daily log files.


## Get Tasks

```shell
curl "https://abs.example.com/api/tasks" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "tasks": [
    {
      "id": "task_1234567890",
      "type": "encode-m4b",
      "status": "active",
      "data": {
        "libraryItemId": "li_8gch9ve09orgn4fdz8",
        "libraryItemTitle": "Wizards First Rule"
      },
      "startedAt": 1234567890,
      "finishedAt": null
    }
  ]
}
```

This endpoint retrieves all active and recent background tasks.

### HTTP Request

`GET http://abs.example.com/api/tasks`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`tasks` | Array of Task Objects | List of background tasks.

#### Task Object

Attribute | Type | Description
--------- | ---- | -----------
`id` | String | The task ID.
`type` | String | The type of task (e.g., "encode-m4b", "embed-metadata").
`status` | String | The task status ("active", "completed", "failed").
`data` | Object | Task-specific data.
`startedAt` | Integer | Timestamp when the task started.
`finishedAt` | Integer or null | Timestamp when the task finished, or null if still active.
