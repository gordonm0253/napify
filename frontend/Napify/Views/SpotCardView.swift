//
//  SpotCardView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct SpotCardView: View {

    let review: Review
    let spotName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            // show image if there is one
            if let imageData = review.imageData,
               let data = Data(base64Encoded: imageData),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Rectangle()
                    .fill(Color(UIColor.napify.lightGray))
                    .frame(height: 180)
                    .cornerRadius(16)
            }

            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 4){
                    Text(spotName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.black))

                    if let hint = review.locationHint, !hint.isEmpty {
                        Text(hint)
                            .font(.caption)
                            .foregroundStyle(Color(UIColor.napify.silver))
                    }
                }

                Spacer()

                // star rating
                HStack(spacing: 2){
                    ForEach(0..<5) { i in
                        Image(systemName: Double(i) < review.rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(Color(UIColor.napify.amber))
                    }
                    Text(String(format: "%.1f", review.rating))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.amber))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.napify.offWhite))
                .cornerRadius(8)
            }

            if let notes = review.notes, !notes.isEmpty {
                Text(notes)
                    .font(.subheadline)
                    .foregroundStyle(Color(UIColor.napify.darkGray))
                    .lineLimit(3)
            }

            HStack {
                HStack(spacing: 4){
                    Image(systemName: "moon.zzz")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.napify.amber))
                    Text("\(review.napDuration) min nap")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.napify.silver))
                }

                Spacer()
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
    SpotCardView(
        review: Review.mockData[0],
        spotName: "Uris Hall"
    )
    .background(Color(UIColor.napify.offWhite))
}
