//
//  ContentView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/26/26.
//

import SwiftUI

struct ContentView: View {

    @State private var authVM = AuthViewModel()

    var body: some View {
        if authVM.isLoggedIn {
            TabView {
                FeedView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Feed")
                    }

                SpotsView()
                    .tabItem {
                        Image(systemName: "building.2.fill")
                        Text("Buildings")
                    }

                CreatePostView(username: authVM.username, password: authVM.password)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Post")
                    }

                ProfileView(authVM: authVM, onLogout: {
                    authVM.logout()
                })
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            .tint(Color(UIColor.napify.amber))
        } else {
            LoginView(authVM: authVM)
        }
    }
}

#Preview {
    ContentView()
}
