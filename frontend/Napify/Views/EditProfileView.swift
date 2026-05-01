//
//  EditProfileView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/29/26.
//

import SwiftUI

struct EditProfileView: View {

    @Bindable var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var editName: String = ""
    @State private var editBio: String = ""
    @State private var editHometown: String = ""
    @State private var editMajor: String = ""
    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24){
                    // profile pic and name at top
                    HStack(spacing: 16){
                        Image("mikiPFP")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4){
                            Text(editName.isEmpty ? (authVM.currentUser?.username ?? "") : editName)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color(UIColor.napify.black))

                            if !editBio.isEmpty {
                                Text(editBio)
                                    .font(.system(size: 14).italic())
                                    .foregroundStyle(Color(UIColor.napify.black))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 10)

                    // name field
                    VStack(alignment: .leading, spacing: 8){
                        Text("Name")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.napify.black))

                        TextField("Your name...", text: $editName)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.napify.silver), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 32)

                    // bio field
                    VStack(alignment: .leading, spacing: 8){
                        Text("Bio")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.napify.black))

                        TextField("Your bio...", text: $editBio)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.napify.silver), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 32)

                    // hometown field
                    VStack(alignment: .leading, spacing: 8){
                        Text("Hometown")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.napify.black))

                        TextField("Your hometown...", text: $editHometown)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.napify.silver), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 32)

                    // major field
                    VStack(alignment: .leading, spacing: 8){
                        Text("Major")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.napify.black))

                        TextField("Your major...", text: $editMajor)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(UIColor.napify.silver), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 32)
                }
            }
            .background(Color(UIColor.napify.offWhite))
            .safeAreaInset(edge: .bottom){
                Button(action: { Task { await saveProfile() } }){
                    Text(isSaving ? "Saving..." : "Save")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(UIColor.napify.amber))
                        .cornerRadius(16)
                }
                .disabled(isSaving)
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                .background(Color(UIColor.napify.offWhite))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color(UIColor.napify.amber))
                }
            }
        }
        .onAppear {
            let user = authVM.currentUser
            editName = user?.name ?? ""
            editBio = user?.bio ?? ""
            editHometown = user?.hometown ?? ""
            editMajor = user?.major ?? ""
        }
    }

    func saveProfile() async {
        isSaving = true
        do {
            let updatedUser = try await NetworkManager.shared.updateUser(
                name: editName.isEmpty ? nil : editName,
                bio: editBio.isEmpty ? nil : editBio,
                major: editMajor.isEmpty ? nil : editMajor,
                hometown: editHometown.isEmpty ? nil : editHometown,
                username: authVM.username,
                password: authVM.password
            )
            authVM.currentUser = updatedUser
            await authVM.refreshUser()
            dismiss()
        } catch {
            isSaving = false
        }
    }
}

#Preview {
    EditProfileView(authVM: {
        let vm = AuthViewModel()
        vm.currentUser = User(id: 1, username: "mikiyas", name: "Miki Asmamaw", bio: "Born for CS yet suffering in ChemE", major: "Chemical Engineering", hometown: "Minot, ND", profilePicture: nil, totalNaptime: 520, totalSpots: 12, totalReviews: 7)
        return vm
    }())
}
