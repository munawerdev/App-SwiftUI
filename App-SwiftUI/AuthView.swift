//
//  AuthView.swift
//  swiftUi_practice_project
//
//  Created by Syed Munawer Ali on 08/09/2026.
//

import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()
            VStack {
                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 162)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 382)
                .background(.white)
                .clipShape(.rect(cornerRadius: 30))
                .shadow(
                    color: Color.black.opacity(0.01),
                    radius: 10,
                    x: 0,
                    y: 10
                )
                .ignoresSafeArea()
                AppTextField(
                    title: "Email",
                    text: $viewModel.email,
                    keyboardType: .emailAddress,
                    contentType: .emailAddress,
                    capitalization: .never
                )
                AppSecureField(title: "Password", text: $viewModel.password)

               
                Spacer()

                AppButton(
                    title: "Login",
                    backgroundColor: Color("OnboardingBackgroundColor"),
                    foregroundColor: Color("ButtonTextColor")
                    
                ) {
                    BottomNavBar()
                }
            }

        }
    }
}

#Preview {
    AuthView()
}
