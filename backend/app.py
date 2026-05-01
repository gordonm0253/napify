import json
from flask import Flask, request
from db import db, User, Spot, Review, Save, Tag
import base64
from datetime import datetime as dt
from utils import add_spot_data, add_user_data

# define db filename
db_filename = "napify.db"
app = Flask(__name__)

MAX_IMAGE_BYTES = 10000000 # max image size - 10MB

# setup config
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

# initialize app
db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    '''
    Serialize data as JSON and return it with the given HTTP status code.
    '''
    return json.dumps(data), code

def failure_response(message, code=404):
    '''
    Serialize an error message as JSON and return it with the given HTTP status code.
    '''
    return json.dumps({"error": message}), code

@app.route("/")
def hello():
    return "Hello world!"

# users
@app.route("/user/")
def get_user_info():
    '''
    Return profile information for the currently authenticated user, including aggregated stats (total nap time, spots visited, review count).
    '''
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    user_data = add_user_data(user.serialize())
    return success_response(user_data)

@app.route("/user/", methods=["POST"])
def update_user_info():
    '''
    Update user information based on optional parameters for the currently authenticated user
    '''
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    
    body = json.loads(request.data)
    
    # update only fields that were provided
    if "name" in body:
        user.name = body["name"]
    if "bio" in body:
        user.bio = body["bio"]
    if "major" in body:
        user.major = body["major"]
    if "hometown" in body:
        user.hometown = body["hometown"]
    if "profile_picture" in body:
        user.profile_picture = body["profile_picture"]

    db.session.commit()
    return success_response(user.serialize())

# login/register
@app.route("/register/", methods=["POST"])
def register_user():
    '''
    Create a new user account using HTTP Basic Auth credentials. Registration fails if the
    username is already taken.
    '''
    auth_header = request.headers.get("Authorization")

    if not auth_header or not auth_header.startswith("Basic "):
        return failure_response("Auth header is missing or invalid", 401)
    
    encoded = auth_header[len("Basic "):]
    decoded = base64.b64decode(encoded).decode("utf-8")

    username, password = decoded.split(":")

    user = User.query.filter_by(username=username).first()

    if user is not None:
        return failure_response("User already exists", 400)
    
    new_user = User(username=username, password=password)

    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

def require_basic_auth():
    """
    Validate HTTP Basic Auth credentials from the incoming request.
    """
    auth_header = request.headers.get("Authorization")

    if not auth_header or not auth_header.startswith("Basic "):
        return failure_response("Auth header is missing or invalid", 401)
    
    encoded = auth_header[len("Basic "):]
    decoded = base64.b64decode(encoded).decode("utf-8")

    username, password = decoded.split(":")

    user = User.query.filter_by(username=username).first()

    if user is None:
        return None

    if user.password != password:
        return None

    return user    

@app.route("/auth/login/")
def sign_in():
    '''
    Verify credentials and return the authenticated user's serialized data.
    '''
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    return success_response(user.serialize())

# Routes for spots
@app.route("/spots/")
def get_all_spots():
    '''
    Return a list of all nap spots with their associated reviews and
    computed average rating. No Auth required.
    '''
    spots = [add_spot_data(s.serialize()) for s in Spot.query.all()]
    return success_response({"spots": spots})

@app.route("/spots/<int:spot_id>/")
def get_spot(spot_id):
    '''
    Return a single nap spot by its ID, with reviews and average rating. No Auth required.
    '''
    spot = Spot.query.filter_by(id=spot_id).first()
    if spot is None:
        return failure_response("Spot not found!")
    spot_data = add_spot_data(spot.serialize())
    return success_response(spot_data)
    
# reviews (create/get)-----------

# get all reviews
@app.route("/reviews/")
def get_all_reviews():
    '''
    Return all reviews across every nap spot.
    '''
    reviews = Review.query.all()
    return success_response({"reviews": [r.serialize_without_image() for r in reviews]})

# create a review
@app.route("/reviews/", methods=["POST"])
def create_review():
    '''
    Create a new review for a nap spot, creating the spot itself if it
    does not already exist.
    '''
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)

    body = json.loads(request.data)
    spot_name = body.get("spot_name")
    latitude = body.get("latitude")
    longitude = body.get("longitude")
    rating = body.get("rating")
    nap_duration = body.get("nap_duration")
    location_hint = body.get("location_hint")
    image_data = body.get("image_data")
    notes = body.get("notes")
    tag_names = body.get("tags", [])

    if any(v is None for v in [spot_name, latitude, longitude, rating, nap_duration, image_data]):
        return failure_response("Missing required fields.", 400)
    
    try: # ensure that the image data is good
        decoded = base64.b64decode(image_data, validate=True)
    except Exception:
        return failure_response("Invalid base64 image data", 400)
    if len(decoded) > MAX_IMAGE_BYTES:
        return failure_response("Image too large (max 10MB)", 400)

    spot = Spot.query.filter_by(name=spot_name).first()
    if spot is None:
        spot = Spot(name=spot_name, latitude=latitude, longitude=longitude)
        db.session.add(spot)
        db.session.flush()

    tags = []
    for name in tag_names:
        tag = Tag.query.filter_by(name=name).first()
        if tag is None:
            tag = Tag(name=name)
            db.session.add(tag)
        tags.append(tag)

    new_review = Review(
        user_id=user.id,
        spot_id=spot.id,
        rating=rating,
        nap_duration=nap_duration,
        location_hint=location_hint,
        notes=notes,
        creation_time=dt.now(),
        tags=tags,
        image_data=image_data
    )
    db.session.add(new_review)
    db.session.commit()
    return success_response(new_review.serialize(), 201)

# get a specific post
@app.route("/reviews/<int:review_id>/")
def get_review(review_id):
    '''
    Return a single review by its ID.
    '''
    review = Review.query.filter_by(id=review_id).first()
    if review is None:
        return failure_response("Post not found!")
    return success_response(review.serialize())

# save/unsave posts--------------------

# save a post
@app.route("/spots/<int:spot_id>/save/", methods=["POST"])
def save_spot(spot_id):
    '''
    Save (bookmark) a nap spot for the authenticated user.
    '''
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    
    spot = Spot.query.filter_by(id=spot_id).first()
    if spot is None:
        return failure_response("Spot not found!")
    
    existing = Save.query.filter_by(user_id=user.id, spot_id=spot_id).first()
    if existing is not None:
        return failure_response("Already saved.", 409)
    
    new_save = Save(user_id=user.id, spot_id=spot_id)
    db.session.add(new_save)
    db.session.commit()
    return success_response(new_save.serialize(), 201)

#unsave a post
@app.route("/spots/<int:spot_id>/save/", methods=["DELETE"])
def unsave_spot(spot_id):
    '''
    Remove a previously saved nap spot for the authenticated user.
    '''
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)

    save = Save.query.filter_by(user_id=user.id, spot_id=spot_id).first()
    if save is None:
        return failure_response("Save not found!")

    db.session.delete(save)
    db.session.commit()
    return success_response(save.serialize())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)