from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key = True)
    email = db.Column(db.String, nullable=False)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    

class Spots(db.Model):
    __tablename__ = "spots"
    id = db.Column(db.Integer, primary_key = True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    building_name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    floor = db.Column(db.Integer, nullable=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    creation_time = db.Column(db.DateTime, nullable=False)
    tags = db.Column(db.String, nullable=True)


class Reviews(db.Model):
    __tablename__ = "reviews"
    id = db.Column(db.Integer, primary_key = True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    spot_id = db.Column(db.Integer, db.ForeignKey("spots.id"), nullable=False)
    rating = db.Column(db.Float, nullable=False)
    notes = db.Column(db.String, nullable=True)
    creation_time = db.Column(db.DateTime, nullable=False)


class Saves(db.Model):
    __tablename__ = "saves"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    spot_id = db.Column(db.Integer, db.ForeignKey("spots.id"), nullable=False)