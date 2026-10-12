import Foundation

@MainActor
final class UserUseCases {
    private let userDataSources: UserDataSources
    private let localStorageRepository: LocalStorageBaseApiService

    init(
        _ userDataSources: UserDataSources,
        _ localStorageRepository: LocalStorageBaseApiService
    ) {
        self.userDataSources = userDataSources
        self.localStorageRepository = localStorageRepository
    }

    func execute(userData: [String: Any]) async -> Result<
        UserInfoStoreModel, NetworkFailure
    > {
        // Build the model once (the Dart version rebuilt it three times)
        let model: UserInfoStoreModel
        do {
            model = try UserInfoStoreModel(json: userData)
        } catch {
            return .failure(
                NetworkFailure(
                    error: error.localizedDescription,
                    type: .formatError
                )
            )
        }

        switch await localStorageRepository.setUserData(
            userInfoStoreModel: model
        ) {
        case .failure(let failure):
            return .failure(NetworkFailure(error: failure.error))

        case .success:
            userDataSources.setUserDataSources(userInfoStoreModel: model)
            return .success(model)
        }
    }

    // Handy overload when you already have a decoded model (e.g. from your login response)
    func execute(userInfo: UserInfoStoreModel) async -> Result<
        UserInfoStoreModel, NetworkFailure
    > {
        switch await localStorageRepository.setUserData(
            userInfoStoreModel: userInfo
        ) {
        case .failure(let failure):
            return .failure(NetworkFailure(error: failure.error))
        case .success:
            userDataSources.setUserDataSources(userInfoStoreModel: userInfo)
            return .success(userInfo)
        }
    }
}
