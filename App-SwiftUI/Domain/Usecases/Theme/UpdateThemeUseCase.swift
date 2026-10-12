import Foundation

@MainActor
final class UpdateThemeUseCase {
    private let themeStore: ThemeDataSources
    private let localStorageRepository: LocalStorageBaseApiService

    init(
        _ themeStore: ThemeDataSources,
        _ localStorageRepository: LocalStorageBaseApiService
    ) {
        self.themeStore = themeStore
        self.localStorageRepository = localStorageRepository
    }

    func execute(_ isDarkTheme: Bool) async -> Result<Bool, UpdateThemeFailure>
    {
        themeStore.setTheme(isDarkTheme)

        switch await localStorageRepository.setBool(
            key: GlobalConstants.themeKey,
            value: isDarkTheme
        ) {
        case .failure(let failure):
            return .failure(UpdateThemeFailure(error: failure.error))
        case .success:
            return .success(true)
        }
    }
}
