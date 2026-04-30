from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

review_tags = db.Table("review_tags",
    db.Column("review_id", db.Integer, db.ForeignKey("reviews.id")),
    db.Column("tag_id", db.Integer, db.ForeignKey("tags.id"))
)

class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key = True)
    username = db.Column(db.String, nullable=False, unique=True)
    password = db.Column(db.String, nullable=False)
    
    # Relationships
    reviews = db.relationship('Review', backref='user', lazy=True)
    saves = db.relationship('Save', backref='user', lazy=True)

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
            "reviews": [r.serialize() for r in self.reviews],
            "saves": [s.serialize() for s in self.saves]
        }

class Spot(db.Model):
    __tablename__ = "spots"
    id = db.Column(db.Integer, primary_key = True)
    
    # spot information
    name = db.Column(db.String, nullable=False, unique=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)


    # Relationships
    reviews = db.relationship('Review', backref='spot', lazy=True)
    saves = db.relationship('Save', backref='spot', lazy=True)

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "latitude": self.latitude,
            "longitude": self.longitude,
        }


class Review(db.Model):
    __tablename__ = "reviews"
    id = db.Column(db.Integer, primary_key = True)

    # user who creates the review
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    creation_time = db.Column(db.DateTime, nullable=False)

    # spot information
    spot_id = db.Column(db.Integer, db.ForeignKey("spots.id"), nullable=False)
    location_hint = db.Column(db.String, nullable=True) # where in the building the user is
    
    # nap-specific information
    rating = db.Column(db.Float, nullable=False)
    nap_duration = db.Column(db.Integer, nullable=False)  # nap duration in minutes
    notes = db.Column(db.String, nullable=True) # any review notes on the spot!

    tags = db.relationship("Tag", secondary=review_tags)

    __table_args__ = ( # combination of user_id + spot_id must be unique
        db.UniqueConstraint('user_id', 'spot_id'),
    )

    def serialize(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "spot_id": self.spot_id,
            "location_hint": self.location_hint,
            "creation_time": str(self.creation_time),
            "rating": self.rating,
            "nap_duration": self.nap_duration,
            "notes": self.notes,
            "tags": [t.name for t in self.tags]
        }

class Save(db.Model):
    __tablename__ = "saves"
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False,)
    spot_id = db.Column(db.Integer, db.ForeignKey("spots.id"), nullable=False)
    
    __table_args__ = ( # combination of user_id + spot_id must be unique
        db.UniqueConstraint('user_id', 'spot_id'),
    )

    def serialize(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "spot_id": self.spot_id
        }

class Tag(db.Model):
    __tablename__ = "tags"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False, unique=True)

    def serialize(self):
        return {"id": self.id, "name": self.name}