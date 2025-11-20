# Statistics

## Get Admin Stats for Year

```shell
curl "https://abs.example.com/api/stats/year/2024" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "totalItems": 1234,
  "totalAuthors": 567,
  "totalDuration": 1234567.89,
  "totalSize": 98765432100,
  "totalListeningTime": 456789.12,
  "totalSessions": 890,
  "totalUsers": 15,
  "mostActiveUsers": [
    {
      "userId": "root",
      "username": "root",
      "listeningTime": 123456.78,
      "sessions": 234
    }
  ],
  "topGenres": [
    {
      "genre": "Science Fiction",
      "count": 345,
      "duration": 234567.89
    }
  ],
  "topAuthors": [
    {
      "authorId": "aut_z3leimgybl7uf3y4ab",
      "name": "Brandon Sanderson",
      "count": 45,
      "duration": 123456.78
    }
  ],
  "recentlyAdded": [
    {
      "id": "li_8gch9ve09orgn4fdz8",
      "title": "The Way of Kings",
      "addedAt": 1234567890
    }
  ],
  "year": 2024
}
```

This endpoint retrieves server-wide statistics for a specific year. Admin access is required.

### HTTP Request

`GET http://abs.example.com/api/stats/year/<Year>`

### URL Parameters

Parameter | Description
--------- | -----------
Year | The year to retrieve statistics for (e.g., 2024).

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to view server statistics. |
400 | Bad Request | Invalid year format. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`totalItems` | Integer | Total number of library items on the server.
`totalAuthors` | Integer | Total number of unique authors.
`totalDuration` | Float | Total duration of all media in seconds.
`totalSize` | Integer | Total size of all media in bytes.
`totalListeningTime` | Float | Total listening time across all users in seconds.
`totalSessions` | Integer | Total number of playback sessions.
`totalUsers` | Integer | Total number of users.
`mostActiveUsers` | Array of Objects | List of most active users with listening stats.
`topGenres` | Array of Objects | Most popular genres by count and duration.
`topAuthors` | Array of Objects | Most popular authors by count and duration.
`recentlyAdded` | Array of Objects | Recently added library items.
`year` | Integer | The requested year.


## Get Server Stats

```shell
curl "https://abs.example.com/api/stats/server" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "totalItems": 1234,
  "totalBooks": 1100,
  "totalPodcasts": 134,
  "totalPodcastEpisodes": 3456,
  "totalAuthors": 567,
  "totalDuration": 1234567.89,
  "totalSize": 98765432100,
  "totalListeningTime": 456789.12,
  "totalUsers": 15,
  "totalSessions": 2345,
  "totalLibraries": 3,
  "serverVersion": "2.8.0",
  "serverUptime": 1234567
}
```

This endpoint retrieves overall server statistics. Admin access is required.

### HTTP Request

`GET http://abs.example.com/api/stats/server`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to view server statistics. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`totalItems` | Integer | Total number of library items on the server.
`totalBooks` | Integer | Total number of books.
`totalPodcasts` | Integer | Total number of podcasts.
`totalPodcastEpisodes` | Integer | Total number of podcast episodes.
`totalAuthors` | Integer | Total number of unique authors.
`totalDuration` | Float | Total duration of all media in seconds.
`totalSize` | Integer | Total size of all media in bytes.
`totalListeningTime` | Float | Total listening time across all users in seconds.
`totalUsers` | Integer | Total number of users.
`totalSessions` | Integer | Total number of playback sessions.
`totalLibraries` | Integer | Total number of libraries.
`serverVersion` | String | Current server version.
`serverUptime` | Integer | Server uptime in seconds.

<aside class="notice">
For library-specific statistics, see <a href="#get-a-library-39-s-stats">Get a Library's Stats</a>.
<br>
For user-specific statistics, see <a href="#get-your-listening-stats">Get Your Listening Stats</a> or <a href="#get-a-user-39-s-listening-stats">Get a User's Listening Stats</a>.
</aside>
