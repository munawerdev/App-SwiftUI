import SwiftUI

@MainActor
final class AppContainer {

    // MARK: - Singletons (registerSingleton)
    let userDataSources = UserDataSources()
    let themeDataSources = ThemeDataSources()
    let apiErrorHandler = ApiErrorHandler()
    let localStorage: LocalStorageBaseApiService = LocalStorageRepository()
    //    let show = Show()

    lazy var userUseCases = UserUseCases(userDataSources, localStorage)

    lazy var checkForExistingUser = CheckForExistingUserUseCase(
        userDataSources,
        localStorage
    )

    lazy var network: NetworkBaseApiService = NetworkRepository(
        userDataSources: userDataSources,
        localStorageRepository: localStorage,
        errorHandler: apiErrorHandler
    )

    lazy var getTheme = GetThemeUseCase(localStorage, themeDataSources)
    lazy var updateTheme = UpdateThemeUseCase(themeDataSources, localStorage)

    // MARK: - Factories (registerFactoryParam)

    //    func makeSplashViewModel(
    //        params: SplashInitialParams = SplashInitialParams()
    //    ) -> SplashViewModel {
    //        SplashViewModel(
    //            initialParams: params,
    //            checkForExistingUser: checkForExistingUser,
    //            getTheme: getTheme
    //        )
    //    }
    //
    //    func makeLoginViewModel(
    //        params: LoginInitialParams = LoginInitialParams()
    //    ) -> LoginViewModel {
    //        LoginViewModel(
    //            initialParams: params,
    //            userUseCases: userUseCases,
    //            networkRepository: network,
    //            show: show
    //        )
    //    }
    //
    //    func makeBottomNavViewModel(
    //        params: BottomNavInitialParams = BottomNavInitialParams()
    //    ) -> BottomNavViewModel {
    //        BottomNavViewModel(initialParams: params)
    //    }

    func makeHomeViewModel(
        params: HomeInitialParams = HomeInitialParams()
    ) -> HomeViewModel {
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
