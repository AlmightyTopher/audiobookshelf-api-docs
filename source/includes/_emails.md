# Emails

## Get Email Settings

```shell
curl "https://abs.example.com/api/emails/settings" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "host": "smtp.example.com",
  "port": 587,
  "secure": false,
  "user": "notifications@example.com",
  "pass": "********",
  "fromAddress": "noreply@example.com",
  "testAddress": "test@example.com",
  "ereaderDevices": [
    {
      "name": "My Kindle",
      "email": "mykindle@kindle.com",
      "availabilityOption": "download",
      "users": ["root"]
    }
  ]
}
```

This endpoint retrieves the server's email settings.

### HTTP Request

`GET http://abs.example.com/api/emails/settings`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
403 | Forbidden | An admin user is required to view email settings. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`host` | String | SMTP server hostname.
`port` | Integer | SMTP server port.
`secure` | Boolean | Whether to use TLS/SSL.
`user` | String | SMTP authentication username.
`pass` | String | SMTP authentication password (redacted).
`fromAddress` | String | Email address to send from.
`testAddress` | String | Email address for test emails.
`ereaderDevices` | Array of eReader Device Objects | Configured eReader devices for sending ebooks.


## Update Email Settings

```shell
curl -X PATCH "https://abs.example.com/api/emails/settings" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"host": "smtp.gmail.com", "port": 587, "secure": false, "user": "user@gmail.com", "pass": "app-password", "fromAddress": "noreply@example.com"}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "settings": {
    "host": "smtp.gmail.com",
    "port": 587,
    "secure": false,
    "user": "user@gmail.com",
    "pass": "********",
    "fromAddress": "noreply@example.com",
    "testAddress": "test@example.com",
    "ereaderDevices": []
  }
}
```

This endpoint updates the server's email settings.

### HTTP Request

`PATCH http://abs.example.com/api/emails/settings`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`host` | String | SMTP server hostname.
`port` | Integer | SMTP server port.
`secure` | Boolean | Whether to use TLS/SSL.
`user` | String | SMTP authentication username.
`pass` | String | SMTP authentication password.
`fromAddress` | String | Email address to send from.
`testAddress` | String | Optional. Email address for test emails.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid email settings. |
403 | Forbidden | An admin user is required to update email settings. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the settings were updated successfully.
`settings` | Email Settings Object | The updated email settings.


## Send a Test Email

```shell
curl -X POST "https://abs.example.com/api/emails/test" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY"
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "message": "Test email sent successfully"
}
```

This endpoint sends a test email using the configured email settings.

### HTTP Request

`POST http://abs.example.com/api/emails/test`

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Email settings not configured. |
403 | Forbidden | An admin user is required to send test emails. |
500 | Internal Server Error | Failed to send email. Check server logs for details. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the test email was sent successfully.
`message` | String | Success or error message.


## Update eReader Devices

```shell
curl -X POST "https://abs.example.com/api/emails/ereader-devices" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"ereaderDevices": [{"name": "My Kindle", "email": "mykindle@kindle.com", "availabilityOption": "download", "users": ["root"]}]}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "ereaderDevices": [
    {
      "name": "My Kindle",
      "email": "mykindle@kindle.com",
      "availabilityOption": "download",
      "users": ["root"]
    }
  ]
}
```

This endpoint updates the list of eReader devices that can receive ebooks via email.

### HTTP Request

`POST http://abs.example.com/api/emails/ereader-devices`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`ereaderDevices` | Array of Objects | List of eReader device configurations.

#### eReader Device Object

Attribute | Type | Description
--------- | ---- | -----------
`name` | String | Display name for the device.
`email` | String | Email address of the eReader device (e.g., Kindle email).
`availabilityOption` | String | When the device can receive books. Options: `download`, `adminOrUp`.
`users` | Array of String | User IDs allowed to send to this device.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid eReader device configuration. |
403 | Forbidden | An admin user is required to update eReader devices. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the devices were updated successfully.
`ereaderDevices` | Array of eReader Device Objects | The updated eReader devices.


## Send Ebook to Device

```shell
curl -X POST "https://abs.example.com/api/emails/send-ebook-to-device" \
  -H "Authorization: Bearer exJhbGciOiJI6IkpXVCJ9.eyJ1c2Vyi5NDEyODc4fQ.ZraBFohS4Tg39NszY" \
  -H "Content-Type: application/json" \
  -d '{"libraryItemId": "li_8gch9ve09orgn4fdz8", "deviceName": "My Kindle"}'
```

> The above command returns JSON structured like this:

```json
{
  "success": true,
  "message": "Ebook sent to My Kindle"
}
```

This endpoint sends an ebook to a configured eReader device via email.

### HTTP Request

`POST http://abs.example.com/api/emails/send-ebook-to-device`

### Parameters

Parameter | Type | Description
--------- | ---- | -----------
`libraryItemId` | String | The ID of the library item containing the ebook.
`deviceName` | String | The name of the eReader device to send to.

### Response

Status | Meaning | Description | Schema
------ | ------- | ----------- | ------
200 | OK | Success | See below.
400 | Bad Request | Invalid parameters or no ebook file found. |
403 | Forbidden | User does not have permission to send to this device. |
404 | Not Found | Library item or device not found. |
500 | Internal Server Error | Failed to send email. Check server logs for details. |

#### Response Schema

Attribute | Type | Description
--------- | ---- | -----------
`success` | Boolean | Whether the ebook was sent successfully.
`message` | String | Success or error message.

<aside class="notice">
The ebook is automatically converted to a compatible format for the device if necessary (e.g., MOBI for Kindle).
</aside>
