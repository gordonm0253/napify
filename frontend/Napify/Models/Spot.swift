//
//  Spot.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/27/26.
//

import Foundation

struct Spot: Codable, Identifiable {
    let id: Int
    let name: String
    let avgRating: Double?
    let reviews: [Review]?

    static let cornellBuildings: [String] = [
        "Baker Laboratory",
        "Barton Hall",
        "Bradfield Hall",
        "Carpenter Hall",
        "Clark Hall",
        "Duffield Hall",
        "Gates Hall",
        "Goldwin Smith Hall",
        "Hollister Hall",
        "Ives Hall",
        "Kennedy Hall",
        "Klarman Hall",
        "Mann Library",
        "Martha Van Rensselaer Hall",
        "Milstein Hall",
        "Olin Hall",
        "Olin Library",
        "Phillips Hall",
        "Physical Sciences Building",
        "Rhodes Hall",
        "Riley-Robb Hall",
        "Rockefeller Hall",
        "Sage Hall",
        "Snee Hall",
        "Statler Hall",
        "Stimson Hall",
        "Stocking Hall",
        "Upson Hall",
        "Uris Hall",
        "Uris Library",
        "Warren Hall",
        "Weill Hall"
    ]

    static let mockData: [Spot] = [
        Spot(id: 1, name: "Uris Hall", avgRating: 4.8, reviews: nil),
        Spot(id: 2, name: "Olin Library", avgRating: 4.0, reviews: nil),
        Spot(id: 3, name: "Physical Sciences Building", avgRating: 4.5, reviews: nil),
        Spot(id: 4, name: "Mann Library", avgRating: 4.3, reviews: nil)
    ]
}
