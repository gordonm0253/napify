# Napify API

## Authentication
All routes except GET /spots/ and GET /reviews/ require HTTP Basic Auth.

Header format:
```
Authorization: Basic base64(username:password)
```

## Endpoints

### User Management
`GET /user/` - Get user profile (auth required)

Response:
```json
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "username": <STORED USERNAME FOR USER WITH ID {id}>,
  "name": <STORED NAME FOR USER WITH ID {id}>,
  "bio": <STORED BIO FOR USER WITH ID {id}>,
  "major": <STORED MAJOR FOR USER WITH ID {id}>,
  "hometown": <STORED HOMETOWN FOR USER WITH ID {id}>,
  "profile_picture": <STORED PICTURE FOR USER WITH ID {id}>,
  "reviews": [
  	<REVIEW>,
  	<REVIEW>,
    ...
  ],
  "saves": [
  	<SAVED SPOT>,
  	<SAVED SPOT>,
    ...
  ],
  "total_naptime": <STORED NAPTIME FOR USER WITH ID {id}, in minutes>,
  "total_spots": <STORED SPOTS VISITED FOR USER WITH ID {id}>,
  "total_reviews": <STORED TOTAL REVIEWS FOR USER WITH ID {id}>
}
```

---

`POST /user/` - Update user info (auth required)

Request Body:
```json
{
  "name": <USER INPUT (OPTIONAL STRING)>,
  "bio": <USER INPUT (OPTIONAL STRING)>,
  "major": <USER INPUT (OPTIONAL STRING)>,
  "hometown": <USER INPUT (OPTIONAL STRING)>,
  "profile_picture": <USER INPUT (OPTIONAL TEXT)>
}
```

Response: 
```json
<HTTP STATUS CODE 201>
{
  "id": <ID>,
  "username": <STORED USERNAME FOR USER WITH ID {id}>,
  "name": <STORED NAME FOR USER WITH ID {id}>,
  "bio": <STORED BIO FOR USER WITH ID {id}>,
  "major": <STORED MAJOR FOR USER WITH ID {id}>,
  "hometown": <STORED HOMETOWN FOR USER WITH ID {id}>,
  "profile_picture": <STORED PICTURE FOR USER WITH ID {id}>,
  "reviews": [
    <REVIEW>,
    <REVIEW>,
    ...
  ],
  "saves": [
    <SAVED SPOT>,
    <SAVED SPOT>,
    ...
  ],
  "total_naptime": <STORED NAPTIME FOR USER WITH ID {id}, in minutes>,
  "total_spots": <STORED SPOTS VISITED FOR USER WITH ID {id}>,
  "total_reviews": <STORED TOTAL REVIEWS FOR USER WITH ID {id}>
}
```
Notes:
- Returns response 401: for invalid authentication

---

### Authentication
`POST /register/` - Create new account

Response:
```json
<HTTP STATUS CODE 201>
{
  "id": <ID>,
  "username": <username>,
  "name": “”,
  "bio": “”,
  "major": “”,
  "hometown": “”,
  "profile_picture": “”,
  "reviews": [],
  "saves": [],
  "total_naptime": 0,
  "total_spots": 0,
  "total_reviews": 0
}
```
Notes:
- Returns error code 401 if authentication header is missing.
- If the username already exists, the route returns error code 400.

---

`GET /auth/login/` - Login

Response:
```json
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "username": <STORED USERNAME FOR USER WITH ID {id}>,
  "name": <STORED NAME FOR USER WITH ID {id}>,
  "bio": <STORED BIO FOR USER WITH ID {id}>,
  "major": <STORED MAJOR FOR USER WITH ID {id}>,
  "hometown": <STORED HOMETOWN FOR USER WITH ID {id}>,
  "profile_picture": <STORED PICTURE FOR USER WITH ID {id}>,
  "reviews": [
  	<REVIEW>,
  	<REVIEW>,
    ...
  ],
  "saves": [
  	<SAVED SPOT>,
  	<SAVED SPOT>,
    ...
  ],
  "total_naptime": <STORED NAPTIME FOR USER WITH ID {id}, in minutes>,
  "total_spots": <STORED SPOTS VISITED FOR USER WITH ID {id}>,
  "total_reviews": <STORED TOTAL REVIEWS FOR USER WITH ID {id}>
}
```

---

### Spots
`GET /spots/` - Get all spots

Response:
```json
<HTTP STATUS CODE 200>
{
  "spots": [
    {
      "id": <ID>,
      "name": <STRING>,
      "latitude": <FLOAT>,
      "longitude": <FLOAT>,
      "reviews": [
        <REVIEW>,
        <REVIEW>,
        ...
      ],
      "avg_rating": <FLOAT>
    },
    ...
  ]
}
```

---

`GET /spots/<spot_id>/` - Get specific spot by id

Response:
```json
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "name": <STRING>,
  "latitude": <FLOAT>,
  "longitude": <FLOAT>,
  "reviews": [
    <REVIEW>,
    <REVIEW>,
    ...
  ],
  "avg_rating": <FLOAT>
}
```
Notes:
- returns 404 error if no such `spot_id` exists

---

### Reviews
`GET /reviews/` - Get all reviews (without images for performance)

Response:
```json
<HTTP STATUS CODE 200>
{
  "reviews": [
    {
      "id": <ID>,
      "user_id": <USER_ID>,
      "spot_id": <SPOT_ID>,
      "location_hint": <STRING>,
      "creation_time": <TIMESTAMP>,
      "rating": <INTEGER>,
      "nap_duration": <INTEGER>,
      "notes": <STRING>,
      "tags": [
        <TAG>,
        <TAG>,
        ...
      ]
    },
    ...
  ]
  
}
```

---

`POST /reviews/` - Create review (auth required)

Request:
```json
{
  "spot_name": <STRING>,
  "latitude": <FLOAT>,
  "longitude": <FLOAT>,
  "rating": <FLOAT>,
  "nap_duration": <INTEGER>,
  "image_data": <TEXT>,
  "location_hint": <STRING (OPTIONAL)>,
  "notes": <STRING (OPTIONAL)>,
  "tags": <[<STRING>, ...]> (OPTIONAL, defaults to [])
}
```

Response:
```json
<HTTP STATUS CODE 201>
{
  "id": <ID>,
  "user_id": <USER_ID>,
  "spot_id": <SPOT_ID>,
  "location_hint": <STRING>,
  "creation_time": <TIMESTAMP>,
  "image_data": <TEXT>,
  "rating": <INTEGER>,
  "nap_duration": <INTEGER>,
  "notes": <STRING>,
  "tags": [
    <TAG>,
    <TAG>,
    ...
  ]
}
```

Notes:
- Throws error 400 if not all required input fields are supplied
- Throws error 400 if the image is not in base64 format or is larger than 10MB

---

`GET /reviews/<review_id>/` - Get single review (with image)

Response:
```json
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "user_id": <USER_ID>,
  "spot_id": <SPOT_ID>,
  "location_hint": <STRING>,
  "creation_time": <TIMESTAMP>,
  "image_data": <TEXT>,
  "rating": <INTEGER>,
  "nap_duration": <INTEGER>,
  "notes": <STRING>,
  "tags": [
    <TAG>,
    <TAG>,
    ...
  ]
}
```

Notes:
- Returns with 404 error if review is not found

### Saves
`POST /spots/<spot_id>/save/` - Save spot (auth required)
Response:
```json
<HTTP STATUS CODE 201>
{
  "id": <ID>,
  "user_id": <USER_ID>,
  "spot_id": <SPOT_ID>
}
```
Notes:
- A user cannot save a post multiple times; returns 409 error if this happens.

---

`DELETE /spots/<spot_id>/save/` - Unsave spot (auth required)
Response:
```json
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "user_id": <USER_ID>,
  "spot_id": <SPOT_ID>
}
```

Notes:
- Returns 404 error if the post has not previously been saved.

## Example Requests

**Register:**
```json
POST /register/
Authorization: Basic base64(username:password)
```

**Create Review:**

`POST /reviews/`

Response:
```json
{
  "spot_name": "Library",
  "latitude": 42.45,
  "longitude": -76.47,
  "rating": 5.0,
  "nap_duration": 30,
  "image_data": "base64...",
  "notes": "Great spot!"
}
```

**Get Spots:**

`GET /spots/`
Response:
```json
{
  "spots": [
    {
      "id": 1, 
      "name": "Library", 
      "avg_rating": 4.5
    }, 
    ...
  ] 
}
```
