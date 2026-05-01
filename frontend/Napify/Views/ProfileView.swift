//
//  ProfileView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct ProfileView: View {

    @Bindable var authVM: AuthViewModel
    let onLogout: () -> Void

    @State private var showEditProfile: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20){
                HStack {
                    Text("My Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor.napify.black))

                    Spacer()

                    Button(action: onLogout){
                        Text("Log Out")
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

                if let user = authVM.currentUser {
                    // profile pic and name
                    VStack(spacing: 16){
                        Image("mikiPFP")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())

                        Text(user.name ?? user.username)
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(Color(UIColor.napify.black))

                        if let bio = user.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.system(size: 16).italic())
                                .foregroundStyle(Color(UIColor.napify.black))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    // hometown and major
                    VStack(alignment: .leading, spacing: 24){
                        if let hometown = user.hometown, !hometown.isEmpty {
                            HStack(spacing: 12){
                                Image(systemName: "house.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(UIColor.napify.black))
                                Text(hometown)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color(UIColor.napify.black))
                            }
                        }

                        if let major = user.major, !major.isEmpty {
                            HStack(spacing: 12){
                                Image(systemName: "book.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(UIColor.napify.black))
                                Text(major)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color(UIColor.napify.black))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 16)

                    // stats
                    HStack(spacing: 0){
                        statItem(value: "\(user.totalSpots ?? 0)", label: "SPOTS VISITED")
                        statItem(value: formatNapTime(user.totalNaptime ?? 0), label: "TOTAL NAP TIME")
                        statItem(value: "\(user.totalReviews ?? 0)", label: "REVIEWS")
                    }
                    .padding(16)
                    .background(Color(UIColor.napify.white))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
            }
        }
        .background(Color(UIColor.napify.offWhite))
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button(action: { showEditProfile = true }){
                    Text("Edit Profile")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(UIColor.napify.amber))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 80)
            }
            .background(Color(UIColor.napify.offWhite))
        }
        .task {
            await authVM.refreshUser()
        }
        .sheet(isPresented: $showEditProfile){
            EditProfileView(authVM: authVM)
        }
    }

    func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4){
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

    func formatNapTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}

#Preview {
    ProfileView(
        authVM: {
            let vm = AuthViewModel()
            vm.currentUser = User(id: 1, username: "mikiyas", name: "Miki Asmamaw", bio: "Born for CS yet suffering in ChemE", major: "Chemical Engineering", hometown: "Minot, ND", profilePicture: nil, totalNaptime: 520, totalSpots: 12, totalReviews: 7)
            return vm
        }(),
        onLogout: {}
    )
}
