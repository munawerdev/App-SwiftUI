import SwiftUI

struct AppNavigationStack<Root: View>: View {
    @State private var router = Router()
    private let root: Root

    init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            root
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .onboarding: OnboardingView()
                    case .auth: AuthView()
                    case .bottomNavBar: BottomNavBar()
                    case .home: HomeView()
                    case .favorite: FavoriteView()
                    case .detail(let item): DetailView(item: item)
                    }
                }
        }
        .environment(router)
    }
}
