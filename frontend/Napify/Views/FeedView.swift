//
//  FeedView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct FeedView: View {

    @State private var feedVM = FeedViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16){
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

                // filter buttons
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10) {
                        ForEach(feedVM.filters, id: \.self) { filter in
                            Button(action: {
                                feedVM.selectedFilter = filter
                            }) {
                                Text(filter)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(
                                        feedVM.selectedFilter == filter
                                        ? Color(UIColor.napify.white)
                                        : Color(UIColor.napify.darkGray)
                                    )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        feedVM.selectedFilter == filter
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
                    ForEach(feedVM.filteredReviews) { review in
                        SpotCardView(
                            review: review,
                            spotName: feedVM.spotName(for: review)
                        )
                    }
                }
            }
        }
        .background(Color(UIColor.napify.offWhite))
        .safeAreaInset(edge: .bottom) { // found online
            Color.clear.frame(height: 80)
        }
        .task {
            await feedVM.fetchFeed()
        }
    }
}

#Preview {
    FeedView()
}
