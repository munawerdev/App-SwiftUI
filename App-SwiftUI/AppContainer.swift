import SwiftUI

@MainActor
final class AppContainer {

    // MARK: Singletons
    let userDataSources = UserDataSources()
    let themeDataSources = ThemeDataSources()
    let apiErrorHandler = ApiErrorHandler()
    let localStorage: LocalStorageBaseApiService = LocalStorageRepository()

    lazy var userUseCases = UserUseCases(userDataSources, localStorage)
    lazy var checkForExistingUser = CheckForExistingUserUseCase(
        userDataSources,
        localStorage
    )
    lazy var getTheme = GetThemeUseCase(localStorage, themeDataSources)
    lazy var updateTheme = UpdateThemeUseCase(themeDataSources, localStorage)

    lazy var network: NetworkBaseApiService = NetworkRepository(
        userDataSources: userDataSources,
        localStorageRepository: localStorage,
        errorHandler: apiErrorHandler
    )

    // MARK: Factories
    func makeHomeViewModel(params: HomeInitialParams = HomeInitialParams())
        -> HomeViewModel
    {
        HomeViewModel(initialParams: params, networkRepository: network)
    }
}

// MARK: - Environment access

private struct AppContainerKey: EnvironmentKey {
    static let defaultValue: AppContainer? = nil
}

extension EnvironmentValues {
    var container: AppContainer? {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
}
