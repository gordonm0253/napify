//
//  Review.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/27/26.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: Int
    let userId: Int
    let spotId: Int
    let locationHint: String?
    let creationTime: String
    let imageData: String?
    let rating: Double
    let napDuration: Int
    let notes: String?

    static let mockData: [Review] = [
        Review(
            id: 1,
            userId: 1,
            spotId: 1,
            locationHint: "3rd floor chair by the window",
            creationTime: "2026-04-28 14:30:00",
            imageData: nil,
            rating: 5.0,
            napDuration: 45,
            notes: "This my secret spot...best nap of the semester."
        ),
        Review(
            id: 2,
            userId: 2,
            spotId: 2,
            locationHint: "Back corner beanbag",
            creationTime: "2026-04-27 10:15:00",
            imageData: nil,
            rating: 4.0,
            napDuration: 30,
            notes: "Comfy chairs for a tired day"
        ),
        Review(
            id: 3,
            userId: 3,
            spotId: 3,
            locationHint: "Black couches near back wall",
            creationTime: "2026-04-26 16:00:00",
            imageData: nil,
            rating: 4.5,
            napDuration: 25,
            notes: "Black couches are comfyyyy. You'll be woken up by dance practice if you go late though"
        ),
        Review(
            id: 4,
            userId: 1,
            spotId: 4,
            locationHint: "2nd floor study room",
            creationTime: "2026-04-25 12:00:00",
            imageData: nil,
            rating: 4.5,
            napDuration: 60,
            notes: "It's alright but I really needed this nap after a long day. Anything will do at that point"
        )
    ]
}
