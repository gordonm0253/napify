# Napify

Napify is a social nap discovery app for college students. Users can find, rate, and share their favorite nap spots on campus, complete with photos and reviews.

## Tech Stack

**Backend:**
- Flask (Python)
- SQLAlchemy (database)
- SQLite

**Frontend:**
- SwiftUI (iOS app)

## Database Models

- **User**: Stores user accounts and login info
- **Spot**: Physical nap locations with coordinates
- **Review**: User ratings and experiences at spots
- **Save**: Bookmarks for favorite spots
- **Tag**: Categories for reviews

## Main Routes

- `POST /register/` - Create new user account
- `GET /auth/login/` - User login
- `GET /spots/` - Get all nap spots
- `POST /reviews/` - Submit a review for a spot
- `GET /reviews/` - Get all reviews
- `POST /spots/<id>/save/` - Save a spot
- `DELETE /spots/<id>/save/` - Unsave a spot

## Setup

**Backend:**
```bash
cd backend
pip install -r requirements.txt
python app.py
```

**Frontend:**
```bash
cd frontend/Napify
open Napify.xcodeproj
```

Server runs on `http://0.0.0.0:8000`
