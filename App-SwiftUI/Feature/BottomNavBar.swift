//
//  BottomNavBar.swift
//  swiftUi_practice_project
//
//  Created by Syed Munawer Ali on 19/09/2026.
//

import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        TabView {
            HomeView(title: "Hello Home")
                .tabItem { Label("", systemImage: "house") }
            FavoriteView()
                .tabItem { Label("", systemImage: "heart") }
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    BottomNavBar()
}
