import SwiftUI

@main
struct MyApp: App {
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                OnboardingView()
                    .withRouteDestinations()
            }
            .environment(router)
        }
    }
}
