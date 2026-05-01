//
//  CreatePostView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/28/26.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {

    let username: String
    let password: String

    @State private var buildingSearch: String = ""
    @State private var selectedBuilding: String = ""
    @State private var locationHint: String = ""
    @State private var caption: String = ""
    @State private var rating: Int = 0
    @State private var napDuration: String = ""
    @State private var postError: String = ""
    @State private var postSuccess: Bool = false
    @State private var isPosting: Bool = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    var filteredBuildings: [String] {
        if buildingSearch.isEmpty {
            return []
        }
        return Spot.cornellBuildings.filter {
            $0.localizedCaseInsensitiveContains(buildingSearch)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20){
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(Color(UIColor.napify.amber))
                        .font(.title2)

                    Text("New Post")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor.napify.black))
                }
                .padding(.horizontal, 24)

                // photo section
                VStack(alignment: .leading, spacing: 8){
                    Text("Photo")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images){
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .font(.subheadline)
                            Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(Color(UIColor.napify.amber))
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.napify.white))
                        .cornerRadius(10)
                    }
                    .onChange(of: selectedPhoto){
                        Task {
                            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                                selectedImage = UIImage(data: data)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                // building search
                VStack(alignment: .leading, spacing: 8){
                    Text("Building")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))

                    if selectedBuilding.isEmpty {
                        TextField("Search for a building...", text: $buildingSearch)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        ForEach(filteredBuildings, id: \.self){ building in
                            Button(action: {
                                selectedBuilding = building
                                buildingSearch = ""
                            }){
                                HStack(spacing: 8){
                                    Image(systemName: "building.2")
                                        .font(.caption)
                                        .foregroundStyle(Color(UIColor.napify.amber))
                                    Text(building)
                                        .font(.subheadline)
                                        .foregroundStyle(Color(UIColor.napify.black))
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.napify.white))
                                .cornerRadius(10)
                            }
                        }
                    } else {
                        HStack {
                            Text(selectedBuilding)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color(UIColor.napify.black))

                            Spacer()

                            Button(action: {
                                selectedBuilding = ""
                            }){
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color(UIColor.napify.silver))
                            }
                        }
                        .padding(12)
                        .background(Color(UIColor.napify.white))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)

                // location hint
                VStack(alignment: .leading, spacing: 8){
                    Text("Where in the building?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))

                    TextField("e.g. 3rd floor chair by the window", text: $locationHint)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, 24)

                // caption
                VStack(alignment: .leading, spacing: 8){
                    Text("Caption")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))

                    TextField("Describe your nap...", text: $caption)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)

                // star rating
                VStack(alignment: .leading, spacing: 8){
                    Text("Rating")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))

                    HStack(spacing: 8){
                        ForEach(1...5, id: \.self){ star in
                            Button(action: {
                                rating = star
                            }){
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundStyle(Color(UIColor.napify.amber))
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                // nap duration
                VStack(alignment: .leading, spacing: 8){
                    Text("Nap Duration (minutes)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(UIColor.napify.darkGray))

                    TextField("e.g. 45", text: $napDuration)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal, 24)

                if !postError.isEmpty {
                    Text(postError)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 24)
                }

                if postSuccess {
                    Text("Review posted!")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 24)
                }

                // post button
                Button {
                    Task { await submitPost() }
                } label: {
                    Text(isPosting ? "Posting..." : "Post")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(UIColor.napify.amber))
                        .cornerRadius(12)
                }
                .disabled(isPosting || selectedBuilding.isEmpty || rating == 0 || napDuration.isEmpty || selectedImage == nil)
                .padding(.horizontal, 24)
            }
        }
        .background(Color(UIColor.napify.offWhite))
        .safeAreaInset(edge: .bottom){
            Color.clear.frame(height: 80)
        }
    }

    func submitPost() async {
        isPosting = true
        guard let image = selectedImage,
              let jpegData = image.jpegData(compressionQuality: 0.7) else {
            postError = "Please add a photo."
            isPosting = false
            return
        }
        let base64String = jpegData.base64EncodedString()

        do {
            let duration = Int(napDuration) ?? 0
            _ = try await NetworkManager.shared.createReview(
                spotName: selectedBuilding,
                rating: Double(rating),
                napDuration: duration,
                locationHint: locationHint.isEmpty ? nil : locationHint,
                notes: caption.isEmpty ? nil : caption,
                imageData: base64String,
                username: username,
                password: password
            )
            postError = ""
            postSuccess = true
            // reset all the fields
            selectedBuilding = ""
            buildingSearch = ""
            locationHint = ""
            caption = ""
            rating = 0
            napDuration = ""
            selectedPhoto = nil
            selectedImage = nil
            isPosting = false
        } catch {
            postError = "Failed to post review."
            postSuccess = false
            isPosting = false
        }
    }
}

#Preview {
    CreatePostView(username: "test", password: "test")
}
