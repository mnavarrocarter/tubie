# Implementando OAuth en Vala

Todas las API de Google necesitan un `access_token` para funcionar junto 
con el request. Estos `access_token` se obtienen con un `authorization_code` 
y éste, a su vez, se obtiene cuando un usuario ha dado permiso a tu 
aplicación a través de OAuth.

Vala utiliza cURL para realizar requests a diferentes servicios. Estos son 
los pasos para implementar.

## Creando una Aplicación en Google API Console

Nos da un `client_id`y un `client_secret`. En mi caso son:

```
client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com

client_secret=wjZQcOogfigsK8Z6MficU9Rp
```

## Realizando un HTTP Request a OAuth

Debemos hacer un request a `https://accounts.google.com/o/oauth2/v2/auth` 
poniendo los siguientes parámetros GET en la URL.

```
client_id: el ID de Cliente de tu aplicación.
redirect_uri: urn:ietf:wg:oauth:2.0:oob Copy/Paste manual, para apps linux de escritorio.
scope: el tipo de permiso. 
response_type: tipo de respuesta. Debe ser 'code'.
login_hint: la cuenta de la cual se requiere acceso (opcional).
```

La URL final, en mi caso:

```
https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.upload&response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com
```

## Cambiando un `authoization_code` por un `access_token`

Para esto, se debe hacer un POST request a `https://www.googleapis.com/oauth2/v4/token` 
con `Content-Type: application/x-www-form-urlencoded` y los siguientes 
parámetros:

```
code=4/-NeG9WMU5stoIiD9Y49ECaamnRtXZsQFRerperpp2OE
client_id=
client_secret=
redirect_uri=https://oauth2.example.com/code
grant_type=authorization_code
```

## Guardando el Access Token en Gnome Keyring

La respuesta será, en mi caso:

```
{
    "access_token": "ya29.GluVBP3Jmu9zAT2Uhi0Mk-o4NkYFRycHMgGI6mXJ_Isx79fCOHHxRlxKg0CjoMjxjYUCALvZQ1H8f8PGR6XTPouUgKchnesEkZKKQNKK6-5-CkNn2GNIJQ9uGZFu",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "1/GrNY9MjaIoVUZ7hSs5pf7lG6TiYgcaU0OvcPFTrTifk"
}
```

## Haciendo el Request de subir Video

First, make a POST request for an upload url to:

"https://www.googleapis.com/upload/youtube/v3/videos"
You will need to send 2 headers:

"Authorization": "Bearer {YOUR_ACCESS_TOKEN}"
"Content-type": "application/json"
You need to send 3 parameters:

"uploadType": "resumable"
"part": "snippet, status"
"key": {YOUR_API_KEY}
And you will need to send the metadata for the video in the request body:

```
    {
        "snippet": {
            "title": {VIDEO TITLE},
            "description": {VIDEO DESCRIPTION},
            "tags": [{TAGS LIST}],
            "categoryId": {YOUTUBE CATEGORY ID}
        },
        "status": {
            "privacyStatus": {"public", "unlisted" OR "private"}
        }
    }
```

From this request you should get a response with a "location" field in the headers.
POST to custom location to send file.

For the upload you need 1 header:

```
"Authorization": "Bearer {YOUR_ACCESS_TOKEN}"
```

And send the file as your data/body.

If you read through how their client works you will see they recommend retrying if you are returned errors of code 500, 502, 503, or 504. Clearly you will want to have a wait period between retries and a max number of retries. It works in my system every time, though I am using python & urllib2 instead of cURL.

Also, because of the custom upload location this version is upload resumable capable, though I have yet to need that.