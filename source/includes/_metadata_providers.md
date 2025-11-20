# Metadata Providers

## Get All Custom Metadata Providers

```shell
curl "https://abs.example.com/api/custom-metadata-providers" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "customMetadataProviders": [
    {
      "id": "cmp_1234567890",
      "name": "Custom Provider",
      "url": "https://api.customprovider.com/search",
      "mediaType": "book",
      "authHeaderValue": null,
      "createdAt": 1234567890
    }
  ]
}
```

This endpoint retrieves all configured custom metadata providers.

### HTTP Request

`GET http://abs.example.com/api/custom-metadata-providers`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to view custom metadata providers. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`customMetadataProviders` | Array of Custom Metadata Provider Objects | List of custom providers.


## Create a Custom Metadata Provider

```shell
curl -X POST "https://abs.example.com/api/custom-metadata-providers" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"name": "My Custom Provider", "url": "https://api.example.com/search", "mediaType": "book", "authHeaderValue": "Bearer abc123"}'
```

> The above command returns JSON structured like this:

```json
{
  "customMetadataProvider": {
    "id": "cmp_1234567890",
    "name": "My Custom Provider",
    "url": "https://api.example.com/search",
    "mediaType": "book",
    "authHeaderValue": "Bearer abc123",
    "createdAt": 1234567890
  }
}
```

This endpoint creates a new custom metadata provider.

### HTTP Request

`POST http://abs.example.com/api/custom-metadata-providers`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`name` | String | The name of the custom provider.
`url` | String | The API URL for the metadata provider.
`mediaType` | String | The type of media this provider supports. Must be `book` or `podcast`.
`authHeaderValue` | String or null | Optional. Authorization header value for API requests.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid parameters. |
403 | Forbidden | An admin user is required to create custom metadata providers. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`customMetadataProvider` | Custom Metadata Provider Object | The created custom provider.


## Delete a Custom Metadata Provider

```shell
curl -X DELETE "https://abs.example.com/api/custom-metadata-providers/cmp_1234567890" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

This endpoint deletes a custom metadata provider.

### HTTP Request

`DELETE http://abs.example.com/api/custom-metadata-providers/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the custom metadata provider to delete.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
403 | Forbidden | An admin user is required to delete custom metadata providers.
404 | Not Found | Custom metadata provider not found.


## Built-in Metadata Providers

### Books

Value | Display Name
----- | ------------
`google` | Google Books
`openlibrary` | Open Library
`itunes` | iTunes
`audible` | Audible.com
`audible.ca` | Audible.ca
`audible.uk` | Audible.co.uk
`audible.au` | Audible.com.au
`audible.fr` | Audible.fr
`audible.de` | Audible.de
`audible.jp` | Audible.co.jp
`audible.it` | Audible.it
`audible.in` | Audible.co.in
`audible.es` | Audible.es
`fantlab` | FantLab.ru

### Podcasts

Value | Display Name
----- | ------------
`itunes` | iTunes
