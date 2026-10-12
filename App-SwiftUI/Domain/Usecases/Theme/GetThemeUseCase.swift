import Foundation

@MainActor
final class GetThemeUseCase {
    private let localStorageRepository: LocalStorageBaseApiService
    private let themeStore: ThemeDataSources

    init(
        _ localStorageRepository: LocalStorageBaseApiService,
        _ themeStore: ThemeDataSources
    ) {
        self.localStorageRepository = localStorageRepository
        self.themeStore = themeStore
    }

    func execute() async -> Result<Void, GetThemeFailure> {
        switch await localStorageRepository.getBool(
            key: GlobalConstants.themeKey
        ) {
        case .failure(let failure):
            return .failure(GetThemeFailure(error: failure.error))

        case .success(let isDarkTheme):
            themeStore.setTheme(isDarkTheme)
            return .success(())
        }
    }
}
