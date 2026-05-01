//
//  FeedViewModel.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/28/26.
//

import Foundation

@Observable
class FeedViewModel {

    var reviews: [Review] = []
    var spots: [Spot] = []
    var selectedFilter: String = "New"
    let filters = ["Top Rated", "New"]

    func fetchFeed() async {
        do {
            spots = try await NetworkManager.shared.fetchSpots()
            reviews = try await NetworkManager.shared.fetchReviews()
        } catch {
            spots = Spot.mockData
            reviews = Review.mockData
        }
    }

    // get building name from spot id
    func spotName(for review: Review) -> String {
        spots.first(where: { $0.id == review.spotId })?.name ?? "Unknown"
    }
}
