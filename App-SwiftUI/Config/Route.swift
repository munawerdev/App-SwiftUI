import SwiftUI

enum Route: Hashable {
    case onboarding
    case auth
    case bottomNavBar
    case home
    case favorite
    case detail(item: String)
    
    case test
}
