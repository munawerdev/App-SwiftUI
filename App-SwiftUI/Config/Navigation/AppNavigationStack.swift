import SwiftUI

struct AppNavigationStack<Root: View>: View {

    @State private var router = Router()

    private let container: AppContainer
    private let root: Root

    init(
        container: AppContainer,
        @ViewBuilder root: () -> Root
    ) {
        self.container = container
        self.root = root()
    }

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            root
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .onboarding:
            OnboardingView()

        case .auth:
            AuthView()

        case .bottomNavBar:
            BottomNavBar(
                homeViewModel: container.makeHomeViewModel()
            )

        case .home:
            HomeView(
                viewModel: container.makeHomeViewModel()
            )

        case .favorite:
            FavoriteView()

        case .foodDetail(let item):
            FoodDetailView(item: item)
        }
    }
}
