//
//  FeedView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct FeedView: View {

    @State private var selectedFilter: String = "Top Rated"
    let filters = ["Top Rated", "Nearest", "New"]

    @State private var spots: [NapSpot] = [
        NapSpot(
            name: "Uris Hall 3rd Floor",
            building: "Uris Library",
            floor: "3rd",
            description: "This my secret spot...best nap of the semester.",
            rating: 5.0,
            tags: ["Quiet", "Dark", "Cozy"],
            napDuration: 45,
            likes: 24,

            timestamp: Date().addingTimeInterval(-2 * 60 * 60)
        ),
        NapSpot(
            name: "Olin Reading Room",
            building: "Olin Library",
            floor: "1st",
            description: "Comfy chairs for a tired day",
            rating: 4.0,
            tags: ["Low-Light", "Comfy"],
            napDuration: 30,
            likes: 18,

            timestamp: Date().addingTimeInterval(-5 * 60 * 60)
        ),
        NapSpot(
            name: "Physical Sciences Atrium",
            building: "PSB Atrium",
            floor: "Ground",
            description: "Black couches are comfyyyy. You'll be woken up by dance practice if you go late though",
            rating: 4.5,
            tags: ["Spacious", "Quiet"],
            napDuration: 25,
            likes: 12,

            timestamp: Date().addingTimeInterval(-24 * 60 * 60)
        ),
        NapSpot(
            name: "Mann Library 2nd Floor",
            building: "Mann Library",
            floor: "2nd",
            description: "It's alright but I really needed this nap after a long day. Anything will do at that point",
            rating: 4.5,
            tags: ["Cozy", "Warm"],
            napDuration: 60,
            likes: 31,

            timestamp: Date().addingTimeInterval(-48 * 60 * 60)
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(Color(UIColor.napify.amber))
                        .font(.title2)

                    Text("Napify")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor.napify.black))

                    Spacer()
                }
                .padding(.horizontal, 24)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                            }) {
                                Text(filter)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(
                                        selectedFilter == filter
                                            ? Color(UIColor.napify.white)
                                            : Color(UIColor.napify.darkGray)
                                    )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedFilter == filter
                                            ? Color(UIColor.napify.amber)
                                            : Color(UIColor.napify.lightGray)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                LazyVStack {
                    ForEach(spots) { spot in
                        NapSpotCardView(spot: spot)
                    }
                }
            }
        }
        .background(Color(UIColor.napify.offWhite))
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 80)
        }
    }
}

#Preview {
    FeedView()
}
