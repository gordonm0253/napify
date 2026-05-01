from db import Spot, Review

def add_spot_data(spot_data):
    '''
    Given spot data, append 
    '''
    ratings = [r["rating"] for r in spot_data["reviews"]]
    average_rating = sum(ratings) / len(ratings)
    spot_data["avg_rating"] = average_rating
    return spot_data

def add_user_data(user_data):
    '''
    
    '''
    total_naptime = 0
    spots = set([])
    for r in user_data["reviews"]:
        total_naptime += r["nap_duration"]
        spots.add(r["spot_id"])
    user_data["total_naptime"] = total_naptime
    user_data["total_spots"] = len(spots)
    user_data["total_reviews"] = len(user_data["reviews"])
    return user_data