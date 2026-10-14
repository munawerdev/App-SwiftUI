import Foundation

@MainActor
final class AppContainer {

    // MARK: - Shared dependencies

    let userDataSources = UserDataSources()
    let themeDataSources = ThemeDataSources()
    let apiErrorHandler = ApiErrorHandler()

    let localStorage: LocalStorageBaseApiService =
        LocalStorageRepository()

    // MARK: - Use cases

    lazy var userUseCases = UserUseCases(
        userDataSources,
        localStorage
    )

    lazy var checkForExistingUser = CheckForExistingUserUseCase(
        userDataSources,
        localStorage
    )

    lazy var getTheme = GetThemeUseCase(
        localStorage,
        themeDataSources
    )

    lazy var updateTheme = UpdateThemeUseCase(
        themeDataSources,
        localStorage
    )

    // MARK: - Networking

    lazy var network: NetworkBaseApiService = NetworkRepository(
        userDataSources: userDataSources,
        localStorageRepository: localStorage,
        errorHandler: apiErrorHandler
    )

    // MARK: - ViewModel factories

    func makeHomeViewModel(
        params: HomeInitialParams = HomeInitialParams()
    ) -> HomeViewModel {
        HomeViewModel(
            initialParams: params,
            networkRepository: network
        )
    }

    // Add factories as features are implemented:
    //
    // func makeLoginViewModel() -> LoginViewModel
    // func makeFavoriteViewModel() -> FavoriteViewModel
    // func makeFoodDetailViewModel(id: Int) -> FoodDetailViewModel
}
