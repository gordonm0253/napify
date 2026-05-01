//
//  NetworkManager.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/27/26.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()
    private let baseURL = Secrets.baseURL

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // auth stuff

    func register(username: String, password: String) async throws -> User {
        let url = URL(string: "\(baseURL)/register/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(User.self, from: data)
    }

    func login(username: String, password: String) async throws -> User {
        let url = URL(string: "\(baseURL)/auth/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(User.self, from: data)
    }

    // spots

    func fetchSpots() async throws -> [Spot] {
        let url = URL(string: "\(baseURL)/spots/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try decoder.decode([String: [Spot]].self, from: data)
        return response["spots"] ?? []
    }

    func fetchUserInfo(username: String, password: String) async throws -> User {
        let url = URL(string: "\(baseURL)/user/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(User.self, from: data)
    }

    func updateUser(name: String?, bio: String?, major: String?, hometown: String?, username: String, password: String) async throws -> User {
        let url = URL(string: "\(baseURL)/user/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        var body: [String: Any] = [:]
        if let name = name { body["name"] = name }
        if let bio = bio { body["bio"] = bio }
        if let major = major { body["major"] = major }
        if let hometown = hometown { body["hometown"] = hometown }

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(User.self, from: data)
    }

    // reviews

    func fetchReviews() async throws -> [Review] {
        let url = URL(string: "\(baseURL)/reviews/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try decoder.decode([String: [Review]].self, from: data)
        return response["reviews"] ?? []
    }

    func fetchReview(reviewId: Int) async throws -> Review {
        let url = URL(string: "\(baseURL)/reviews/\(reviewId)/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(Review.self, from: data)
    }

    func createReview(spotName: String, rating: Double, napDuration: Int, locationHint: String?, notes: String?, imageData: String, username: String, password: String) async throws -> Review {
        let url = URL(string: "\(baseURL)/reviews/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        var body: [String: Any] = [
            "spot_name": spotName,
            "rating": rating,
            "nap_duration": napDuration,
            "latitude": 0.0,
            "longitude": 0.0,
            "image_data": imageData
        ]
        if let locationHint = locationHint, !locationHint.isEmpty {
            body["location_hint"] = locationHint
        }
        if let notes = notes, !notes.isEmpty {
            body["notes"] = notes
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(Review.self, from: data)
    }

    // saves

    func saveSpot(spotId: Int, username: String, password: String) async throws {
        let url = URL(string: "\(baseURL)/spots/\(spotId)/save/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        let (_, _) = try await URLSession.shared.data(for: request)
    }

    func unsaveSpot(spotId: Int, username: String, password: String) async throws {
        let url = URL(string: "\(baseURL)/spots/\(spotId)/save/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")

        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
