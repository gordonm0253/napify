//
//  SpotsView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 5/1/26.
//

import SwiftUI

struct SpotsView: View {

    @State private var spots: [Spot] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16){
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundStyle(Color(UIColor.napify.amber))
                            .font(.title2)

                        Text("Buildings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.napify.black))

                        Spacer()
                    }
                    .padding(.horizontal, 24)

                    LazyVStack(spacing: 12){
                        ForEach(spots) { spot in
                            NavigationLink(destination: SpotDetailView(spot: spot)){
                                buildingCard(spot: spot)
                            }
                        }
                    }
                }
            }
            .background(Color(UIColor.napify.offWhite))
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
            .task {
                do {
                    spots = try await NetworkManager.shared.fetchSpots()
                } catch {
                    spots = Spot.mockData
                }
            }
        }
    }

    // building card row
    func buildingCard(spot: Spot) -> some View {
        HStack(spacing: 16){
            Image(systemName: "building.2")
                .font(.title2)
                .foregroundStyle(Color(UIColor.napify.amber))
                .frame(width: 50, height: 50)
                .background(Color(UIColor.napify.offWhite))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4){
                Text(spot.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(UIColor.napify.black))

                let count = spot.reviews?.count ?? 0
                Text("\(count) review\(count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.napify.silver))
            }

            Spacer()

            HStack(spacing: 4){
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.napify.amber))
                Text(String(format: "%.1f", spot.avgRating ?? 0.0))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(UIColor.napify.amber))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(UIColor.napify.offWhite))
            .cornerRadius(8)
        }
        .padding(16)
        .background(Color(UIColor.napify.white))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 24)
    }
}

#Preview {
    SpotsView()
}
