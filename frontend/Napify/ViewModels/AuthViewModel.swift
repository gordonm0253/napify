//
//  AuthViewModel.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/28/26.
//

import Foundation

@Observable
class AuthViewModel {

    var currentUser: User? = nil
    var username: String = ""
    var password: String = ""
    var errorMessage: String = ""
    var isLoggedIn: Bool = false

    func register() async {
        do {
            _ = try await NetworkManager.shared.register(username: username, password: password)
            let user = try await NetworkManager.shared.fetchUserInfo(username: username, password: password)
            currentUser = user
            isLoggedIn = true
            errorMessage = ""
        } catch {
            errorMessage = "Registration failed."
        }
    }

    func login() async {
        do {
            _ = try await NetworkManager.shared.login(username: username, password: password)
            let user = try await NetworkManager.shared.fetchUserInfo(username: username, password: password)
            currentUser = user
            isLoggedIn = true
            errorMessage = ""
        } catch {
            errorMessage = "Invalid username or password."
        }
    }

    // skip for demo purposes
    func skipLogin(){
        currentUser = User(id: 0, username: "mikiyas", name: "Miki Asmamaw", bio: nil, major: nil, hometown: nil, profilePicture: nil, totalNaptime: 520, totalSpots: 12, totalReviews: 7)
        isLoggedIn = true
    }

    func refreshUser() async {
        do {
            let user = try await NetworkManager.shared.fetchUserInfo(username: username, password: password)
            currentUser = user
        } catch {}
    }

    func logout(){
        currentUser = nil
        isLoggedIn = false
        username = ""
        password = ""
    }
}
