import SwiftUI

enum Route: Hashable {
    case onboarding
    case auth
    case bottomNavBar
    case home
    case favorite
    case foodDetail(item: FoodItem)
    //    case detail(item: String)
    //
    //    case test
}
