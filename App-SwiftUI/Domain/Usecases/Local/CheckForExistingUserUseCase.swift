import Foundation

@MainActor
final class CheckForExistingUserUseCase {
    private let userDataSources: UserDataSources
    private let localStorageRepository: LocalStorageBaseApiService

    init(
        _ userDataSources: UserDataSources,
        _ localStorageRepository: LocalStorageBaseApiService
    ) {
        self.userDataSources = userDataSources
        self.localStorageRepository = localStorageRepository
    }

    func execute() async -> Result<UserInfoStoreModel, ExistingUserFailure> {
        switch await localStorageRepository.getUserData() {
        case .failure(let failure):
            return .failure(ExistingUserFailure(error: failure.error))

        case .success(let localUser):
            if !localUser.accessToken.isEmpty {
                userDataSources.setUserDataSources(
                    userInfoStoreModel: localUser
                )
                return .success(localUser)
            }
            return .failure(ExistingUserFailure(error: "User doesn't exist"))
        }
    }
}
