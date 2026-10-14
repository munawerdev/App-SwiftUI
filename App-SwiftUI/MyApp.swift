import SwiftUI

@main
struct MyApp: App {

    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppNavigationStack(container: container) {
                OnboardingView()
            }
            .environment(container.userDataSources)
            .environment(container.themeDataSources)
            .preferredColorScheme(
                container.themeDataSources.isDarkTheme
                    ? .dark
                    : .light
            )
            .task {
                await bootstrap()
            }
        }
    }

    private func bootstrap() async {
        _ = await container.getTheme.execute()

        let result =
            await container.checkForExistingUser.execute()

        switch result {
        case .success:
            // Restore the authenticated app flow.
            // Connect this to your actual launch-state handling.
            break

        case .failure:
            // Show onboarding or authentication.
            break
        }
    }
}
