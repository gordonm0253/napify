import json
from flask import Flask, request
from db import db, User, Spots, Reviews, Saves
import base64
from datetime import datetime

# define db filename
db_filename = "napify.db"
app = Flask(__name__)

# setup config
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

# initialize app
db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# users

@app.route("/user/")
def get_user_info():
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)

@app.route("/user/spots/")
def get_user_saved_spots():
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)

# login/register

@app.route("/register/", methods=["POST"])
def register_user():
    auth_header = request.headers.get("Authorization")

    if not auth_header or not auth_header.startswith("Basic "):
        return failure_response("Auth header is missing or invalid", 401)
    
    encoded = auth_header.removeprefix("Basic ")
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
    Helper function for requiing basic authentication
    """

    auth_header = request.headers.get("Authorization")

    if not auth_header or not auth_header.startswith("Basic "):
        return failure_response("Auth header is missing or invalid", 401)
    
    encoded = auth_header.removeprefix("Basic ")
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
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    return success_response(user.serialize())

# posts (create/get)-----------

# get all posts
@app.route("/posts/")
def get_all_posts():
    posts = Spots.query.all()
    return success_response({"posts": [p.to_dict() for p in posts]})

# create a post
@app.route("/posts/", methods=["POST"])
def create_post():
    body = json.loads(request.data)
    user_id = body.get("user_id")
    building_name = body.get("building_name")
    description = body.get("description")
    latitude = body.get("latitude")
    longitude = body.get("longitude")
    creation_time = datetime.utcnow()

    floor = body.get("floor")
    tags = body.get("tags")
    duration = body.get("duration")
    if user_id is None or building_name is None or description is None or latitude is None or longitude is None or creation_time is None:
        return failure_response("Information not provided for creating post.", 400)
    new_post = Spots(user_id = user_id, building_name = building_name, description = description, latitude = latitude, longitude = longitude, creation_time = creation_time, floor = floor, tags = tags, duration = duration)
    db.session.add(new_post)
    db.session.commit()
    return success_response(new_post.to_dict(), 201)

# get a specific post
@app.route("/posts/<int:post_id>/", methods=["GET"])
def get_post(post_id):
    post = Spots.query.filter_by(id=post_id).first()
    if post is None:
        return failure_response("Post not found!")
    return success_response(post.to_dict())

# save/unsave posts--------------------

# save a post
@app.route("/posts/<int:post_id>/save/", methods=["POST"])
def save_post(post_id):
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    user_id = user.id
    
    existing = Saves.query.filter_by(user_id=user_id, spot_id=post_id).first()
    if not existing: #prevent duplicates of save
        new_save = Saves(user_id=user_id, spot_id=post_id)
        db.session.add(new_save)
        db.session.commit()    
        return success_response(new_save, 201)
    else:
        return failure_response("Already saved")

#unsave a post
@app.route("/posts/<int:post_id>/save/", methods=["DELETE"])
def unsave_post(post_id):
    user = require_basic_auth()
    if user is None:
        return failure_response("Invalid credentials", 401)
    user_id = user.id

    save = Saves.query.filter_by(user_id = user_id, spot_id = post_id).first()
    if save is None:
        return failure_response("Save not found!")
    db.session.delete(save)
    db.session.commit()
    return success_response(save)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)