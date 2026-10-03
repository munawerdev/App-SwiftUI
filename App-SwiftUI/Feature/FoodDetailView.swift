//
//  FoodDetailView.swift
//  App-SwiftUI
//
//  Created by Syed Munawer Ali on 03/10/2026.
//

import SwiftUI

struct FoodDetailView: View {
    let item: FoodItem
    var body: some View {
        Text(item.name)
    }
}

#Preview {
    AppNavigationStack {
        FoodDetailView(
            item:
                FoodItem(
                    id: "6",
                    name: "Crunchy snack\nmix",
                    price: "N800",
                    category: "Snacks",
                    imageUrl:
                        "https://images.unsplash.com/photo-1599490659213-e2b9527bd087?auto=format&fit=crop&w=600&q=80"
                ),
        )
    }
}
