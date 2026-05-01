//
//  User.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let name: String?
    let bio: String?
    let major: String?
    let hometown: String?
    let profilePicture: String?
    let totalNaptime: Int?
    let totalSpots: Int?
    let totalReviews: Int?
}
