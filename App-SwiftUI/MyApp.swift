import SwiftUI

@main
struct MyApp: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppNavigationStack {
                OnboardingView()
            }
            .environment(\.container, container)
            .environment(container.userDataSources)
            .environment(container.themeDataSources)
            .preferredColorScheme(
                container.themeDataSources.isDarkTheme ? .dark : .light
            )
            .task { await bootstrap() }
        }
    }

    /// What SplashCubit did at launch: restore the theme and any saved session
    private func bootstrap() async {
        _ = await container.getTheme.execute()

        switch await container.checkForExistingUser.execute() {
        case .success:
            break  // user is logged in: route to your main screen here
        case .failure:
            break  // no saved user: stay on OnboardingView / go to login
        }
    }
}
