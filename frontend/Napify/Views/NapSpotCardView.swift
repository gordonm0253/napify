//
//  NapSpotCardView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct NapSpotCardView: View {

    let spot: NapSpot

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Rectangle()
                .fill(Color(UIColor.napify.lightGray))
                .frame(height: 180)
                .cornerRadius(16)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(spot.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.black))

                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                            .foregroundStyle(Color(UIColor.napify.amber))
                        Text(spot.building)
                            .font(.caption)
                            .foregroundStyle(Color(UIColor.napify.silver))
                    }
                }

                Spacer()

                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        Image(systemName: Double(i) < spot.rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(Color(UIColor.napify.amber))
                    }
                    Text(String(format: "%.1f", spot.rating))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.amber))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.napify.offWhite))
                .cornerRadius(8)
            }

            HStack(spacing: 8) {
                ForEach(spot.tags, id: \.self) { tag in
                    Text(tag.uppercased())
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(UIColor.napify.lightGray))
                        .cornerRadius(6)
                }
            }

            Text(spot.description)
                .font(.subheadline)
                .foregroundStyle(Color(UIColor.napify.darkGray))
                .lineLimit(3)

            HStack {
                HStack(spacing: 4) {
                    Text("z\u{1D553}")
                        .font(.caption)
                    Text("\(spot.napDuration) min nap")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.napify.silver))
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.napify.amber))
                    Text("\(spot.likes)")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.napify.darkGray))
                }

                Image(systemName: "bookmark")
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.napify.silver))
                    .padding(.leading, 8)
            }
        }
        .padding(16)
        .background(Color(UIColor.napify.white))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }
}

#Preview {
    NapSpotCardView(
        spot: NapSpot(
            name: "Uris Hall 3rd Floor",
            building: "Uris Library",
            floor: "3rd",
            description: "This my secret spot...best nap of the semester.",
            rating: 5.0,
            tags: ["Quiet", "Dark", "Cozy"],
            napDuration: 45,
            likes: 24,
            timestamp: Date()
        )
    )
    .background(Color(UIColor.napify.offWhite))
}
