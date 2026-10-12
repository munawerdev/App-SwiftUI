import Foundation

struct FoodItem: Identifiable, Hashable {
    let id: String
    let name: String
    let price: String
    let category: String
    let imageUrl: String
}
