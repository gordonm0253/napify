# Napify API

## Authentication
All routes except GET /spots/ and GET /reviews/ require HTTP Basic Auth.

Header format:
```
Authorization: Basic base64(username:password)
```

## Endpoints

### User Management
- `GET /user/` - Get user profile (auth required)
- `POST /user/` - Update user info (auth required)

### Authentication
- `POST /register/` - Create new account
- `GET /auth/login/` - Login

### Spots
- `GET /spots/` - Get all spots
- `GET /spots/<id>/` - Get single spot

### Reviews
- `GET /reviews/` - Get all reviews
- `POST /reviews/` - Create review (auth required)
- `GET /reviews/<id>/` - Get single review

### Saves
- `POST /spots/<id>/save/` - Save spot (auth required)
- `DELETE /spots/<id>/save/` - Unsave spot (auth required)

## Example Requests

**Register:**
```json
POST /register/
Authorization: Basic base64(username:password)
```

**Create Review:**
```json
POST /reviews/
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
```json
GET /spots/
Response: [{"id": 1, "name": "Library", "avg_rating": 4.5}, ...]
```
