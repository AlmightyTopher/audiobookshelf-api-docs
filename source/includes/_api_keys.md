# API Keys

## Get All API Keys

```shell
curl "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "apiKeys": [
    {
      "id": "apk_1234567890abcdef",
      "name": "My API Key",
      "createdAt": 1234567890,
      "expiresAt": null,
      "isActive": true
    }
  ]
}
```

This endpoint retrieves all API keys for the server.

### HTTP Request

`GET http://abs.example.com/api/api-keys`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to view API keys. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`apiKeys` | Array of API Key Objects | The list of API keys.


## Create an API Key

```shell
curl -X POST "https://abs.example.com/api/api-keys" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"name": "My New API Key", "expiresAt": null}'
```

> The above command returns JSON structured like this:

```json
{
  "apiKey": {
    "id": "apk_1234567890abcdef",
    "name": "My New API Key",
    "key": "sk_1234567890abcdefghijklmnopqrstuvwxyz",
    "createdAt": 1234567890,
    "expiresAt": null,
    "isActive": true
  }
}
```

This endpoint creates a new API key.

### HTTP Request

`POST http://abs.example.com/api/api-keys`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`name` | String | The name of the API key.
`expiresAt` | Integer or null | Optional expiration timestamp. If `null`, the key never expires.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid request parameters. |
403 | Forbidden | An admin user is required to create API keys. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`apiKey` | API Key Object | The created API key. **Note**: The `key` field is only returned on creation.

<aside class="warning">
The API key value is only returned once when created. Make sure to save it securely as it cannot be retrieved again.
</aside>


## Update an API Key

```shell
curl -X PATCH "https://abs.example.com/api/api-keys/apk_1234567890abcdef" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"name": "Updated API Key Name", "isActive": false}'
```

> The above command returns JSON structured like this:

```json
{
  "apiKey": {
    "id": "apk_1234567890abcdef",
    "name": "Updated API Key Name",
    "createdAt": 1234567890,
    "expiresAt": null,
    "isActive": false
  }
}
```

This endpoint updates an existing API key.

### HTTP Request

`PATCH http://abs.example.com/api/api-keys/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the API key to update.

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`name` | String | Optional. The new name for the API key.
`isActive` | Boolean | Optional. Whether the API key is active.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid request parameters. |
403 | Forbidden | An admin user is required to update API keys. |
404 | Not Found | No API key with the provided ID exists. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`apiKey` | API Key Object | The updated API key.


## Delete an API Key

```shell
curl -X DELETE "https://abs.example.com/api/api-keys/apk_1234567890abcdef" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

This endpoint deletes an API key.

### HTTP Request

`DELETE http://abs.example.com/api/api-keys/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the API key to delete.

### Response

Status | Meaning | Description
------ | ------- | -----------
200 | OK | Success
403 | Forbidden | An admin user is required to delete API keys.
404 | Not Found | No API key with the provided ID exists.
