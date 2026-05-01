//
//  LoginView.swift
//  Napify
//
//  Created by Mikiyas Asmamaw on 4/29/26.
//

import SwiftUI

struct LoginView: View {

    @Bindable var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 24){
            Spacer()

            // logo and title
            HStack(spacing: 8){
                Image(systemName: "moon.fill")
                    .foregroundStyle(Color(UIColor.napify.amber))
                    .font(.largeTitle)

                Text("Napify")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.napify.black))
            }

            Text("Find the best nap spots on campus")
                .font(.subheadline)
                .foregroundStyle(Color(UIColor.napify.silver))

            // text fields
            VStack(spacing: 12){
                TextField("Username", text: $authVM.username)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                SecureField("Password", text: $authVM.password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 24)

            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            // login and register buttons
            VStack(spacing: 12){
                Button(action: {
                    Task {
                        await authVM.login()
                    }
                }){
                    Text("Log In")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(UIColor.napify.amber))
                        .cornerRadius(12)
                }
                .disabled(authVM.username.isEmpty || authVM.password.isEmpty)

                Button(action: {
                    Task {
                        await authVM.register()
                    }
                }){
                    Text("Create Account")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(UIColor.napify.amber))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(UIColor.napify.amber), lineWidth: 1)
                        )
                }
                .disabled(authVM.username.isEmpty || authVM.password.isEmpty)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .background(Color(UIColor.napify.offWhite))
    }
}

#Preview {
    LoginView(authVM: AuthViewModel())
}
