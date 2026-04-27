//
//  ProfileView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct ProfileView: View {

    @State private var user = User(
        name: "Mikiyas A.",
        username: "@mikiyasasmamaw",
        school: "Cornell '29",
        avgRating: 4.0,
        spotsVisited: 12,
        totalNapMinutes: 520,
        reviewCount: 7
    )

    @State private var savedSpots: [NapSpot] = [
        NapSpot(
            name: "Uris Hall 3rd Floor",
            building: "Uris Library",
            floor: "3rd",
            description: "",
            rating: 5.0,
            tags: [],
            napDuration: 0,
            likes: 0,

            timestamp: Date()
        ),
        NapSpot(
            name: "Physical Sciences",
            building: "PSB Atrium",
            floor: "Ground",
            description: "",
            rating: 4.5,
            tags: [],
            napDuration: 0,
            likes: 0,

            timestamp: Date()
        ),
        NapSpot(
            name: "Mann Library",
            building: "Mann Library",
            floor: "2nd",
            description: "",
            rating: 4.5,
            tags: [],
            napDuration: 0,
            likes: 0,

            timestamp: Date()
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("My Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor.napify.black))

                    Spacer()

                    Button(action: {}) {
                        Text("Edit")
                            .font(.subheadline)
                            .foregroundStyle(Color(UIColor.napify.darkGray))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.napify.lightGray), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 24)

                HStack(spacing: 16) {
                    Image("ProfilePic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(UIColor.napify.black))

                        Text("\(user.username) · \(user.school)")
                            .font(.caption)
                            .foregroundStyle(Color(UIColor.napify.silver))

                        HStack(spacing: 2) {
                            ForEach(0..<5) { i in
                                Image(systemName: Double(i) < user.avgRating ? "star.fill" : "star")
                                    .font(.caption2)
                                    .foregroundStyle(Color(UIColor.napify.amber))
                            }
                            Text("Avg rating given")
                                .font(.caption2)
                                .foregroundStyle(Color(UIColor.napify.silver))
                        }
                    }
                }
                .padding(.horizontal, 24)

                HStack(spacing: 0) {
                    statItem(value: "\(user.spotsVisited)", label: "SPOTS VISITED")
                    statItem(value: formatNapTime(user.totalNapMinutes), label: "TOTAL NAP TIME")
                    statItem(value: "\(user.reviewCount)", label: "REVIEWS")
                }
                .padding(16)
                .background(Color(UIColor.napify.white))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Saved Spots")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(UIColor.napify.black))

                        Spacer()

                        Button(action: {}) {
                            Text("See all")
                                .font(.caption)
                                .foregroundStyle(Color(UIColor.napify.amber))
                        }
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 8) {
                        ForEach(savedSpots) { spot in
                            savedSpotRow(spot: spot)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.black))
                        .padding(.horizontal, 24)

                    VStack(spacing: 0) {
                        activityRow(
                            action: "Reviewed",
                            spotName: "Uris Hall 3F",
                            detail: "2 days ago · 5\u{2605}",
                            color: Color(UIColor.napify.amber)
                        )

                        Divider()
                            .padding(.horizontal, 16)

                        activityRow(
                            action: "Saved",
                            spotName: "Mann Library",
                            detail: "5 days ago",
                            color: Color(UIColor.napify.silver)
                        )
                    }
                    .padding(.vertical, 8)
                    .background(Color(UIColor.napify.white))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 24)
                }
            }
        }
        .background(Color(UIColor.napify.offWhite))
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 80)
        }
    }

    func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color(UIColor.napify.amber))
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(Color(UIColor.napify.silver))
        }
        .frame(maxWidth: .infinity)
    }

    func savedSpotRow(spot: NapSpot) -> some View {
        HStack {
            Circle()
                .fill(Color(UIColor.napify.lightGray))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "moon.fill")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.napify.amber))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(spot.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
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
            }
        }
        .padding(12)
        .background(Color(UIColor.napify.white))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    func activityRow(action: String, spotName: String, detail: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(action)
                        .font(.subheadline)
                        .foregroundStyle(Color(UIColor.napify.darkGray))
                    Text(spotName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.amber))
                }
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.napify.silver))
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    func formatNapTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}

#Preview {
    ProfileView()
}
