import SwiftUI

extension View {
    func withRouteDestinations() -> some View {
        navigationDestination(for: Route.self) { route in
            switch route {
            case .home: HomeView()
            case .detail(let item): DetailView(item: item)
            }
        }
    }
}
