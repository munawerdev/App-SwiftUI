import Foundation
import Observation

@MainActor
@Observable
final class UserDataSources {
    private(set) var state: UserInfoStoreModel = .empty

    func setUserDataSources(userInfoStoreModel: UserInfoStoreModel) {
        state = userInfoStoreModel
    }
}
