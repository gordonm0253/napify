//
//  SpotDetailView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 5/1/26.
//

import SwiftUI

struct SpotDetailView: View {

    let spot: Spot

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16){
                HStack {
                    VStack(alignment: .leading, spacing: 4){
                        Text(spot.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.napify.black))

                        let count = spot.reviews?.count ?? 0
                        Text("\(count) review\(count == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundStyle(Color(UIColor.napify.silver))
                    }

                    Spacer()

                    // avg rating badge
                    HStack(spacing: 4){
                        Image(systemName: "star.fill")
                            .font(.subheadline)
                            .foregroundStyle(Color(UIColor.napify.amber))
                        Text(String(format: "%.1f", spot.avgRating ?? 0.0))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.napify.amber))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.napify.offWhite))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 24)

                if let reviews = spot.reviews, !reviews.isEmpty {
                    LazyVStack {
                        ForEach(reviews) { review in
                            SpotCardView(review: review, spotName: spot.name)
                        }
                    }
                } else {
                    Text("No reviews yet for this building.")
                        .font(.subheadline)
                        .foregroundStyle(Color(UIColor.napify.silver))
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                }
            }
            .padding(.top, 8)
        }
        .background(Color(UIColor.napify.offWhite))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot.mockData[0])
    }
}
