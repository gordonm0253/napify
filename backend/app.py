import json
from flask import Flask, request
from db import db, User, Spots, Reviews, Saves
from sqlalchemy.exc import IntegrityError
import bcrypt

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

@app.route("/users/<int:user_id>/")
def get_user_by_id(user_id):
    pass

@app.route("/users/<int:user_id>/")
def get_user_saved_spots(user_id):
    pass

# login/register

@app.route("/auth/register/", methods=["POST"])
def register_user():
    body = json.loads(request.data)
    name = body.get("name")
    username = body.get("username")
    pw = body.get("password")
    if name is None or username is None or pw is None:
        return failure_response("name, username, or password is not found")

    hashed_pw = bcrypt.hashpw(pw.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

    new_user = User(name=name, username=username, password=hashed_pw)

    try:
        db.session.add(new_user)
        db.session.commit()
    except IntegrityError:
        db.session.rollback()
        return failure_response("Username already exists", 400)
    
    db.session.commit()
    return success_response(new_user.serialize(), 201)

@app.route("/auth/login/", methods=["POST"])
def sign_in():
    body = json.loads(request.data)
    username = body.get("username")
    pw = body.get("password")
    
    if username is None or pw is None:
        return failure_response("Username or password is missing", 400)
    
    user = User.query.filter_by(username=username).first()

    if user is None:
        return failure_response("Invalid credentials", 401)
    
    if not bcrypt.checkpw(pw.encode("utf-8"), user.password.encode("utf-8")):
        return failure_response("Invalid credentials", 401)
    
    return success_response(user.serialize())

# posts (create/get)

@app.route("/posts/")
def get_all_posts():
    pass

@app.route("/posts/", methods=["POST"])
def create_post():
    pass

@app.route("/posts/<int:post_id>/", methods=["GET"])
def get_post(post_id):
    pass

# save/unsave posts

@app.route("/posts/<int:post_id>/save/", methods=["POST"])
def save_post(post_id):
    pass

@app.route("/posts/<int:post_id>/save/", methods=["DELETE"])
def unsave_post(post_id):
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)