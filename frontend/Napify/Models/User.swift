//
//  User.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()

    let name: String
    let username: String
    let school: String
    let avgRating: Double
    let spotsVisited: Int
    let totalNapMinutes: Int
    let reviewCount: Int
}
