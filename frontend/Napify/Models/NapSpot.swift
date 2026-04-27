//
//  NapSpot.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct NapSpot: Identifiable {
    let id = UUID()

    let name: String
    let building: String
    let floor: String
    let description: String
    let rating: Double
    let tags: [String]
    let napDuration: Int
    let likes: Int
    let timestamp: Date
}
