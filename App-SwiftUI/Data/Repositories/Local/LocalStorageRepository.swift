import Foundation

final class LocalStorageRepository: LocalStorageBaseApiService {
    private let storage = SecureStorage()
    private let userKey = "user_info"

    func setUserData(userInfoStoreModel: UserInfoStoreModel) async -> Result<
        Bool, SetLocalStorageFailure
    > {
        do {
            let data = try JSONEncoder().encode(userInfoStoreModel)
            let json = String(decoding: data, as: UTF8.self)
            try storage.write(key: userKey, value: json)
            return .success(true)
        } catch {
            return .failure(
                SetLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }

    func getUserData() async -> Result<
        UserInfoStoreModel, GetLocalStorageFailure
    > {
        do {
            guard let json = try storage.read(key: userKey) else {
                return .success(.empty)
            }
            let model = try JSONDecoder().decode(
                UserInfoStoreModel.self,
                from: Data(json.utf8)
            )
            return .success(model)
        } catch {
            return .failure(
                GetLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }

    func removeUserData() async -> Result<Bool, RemoveLocalStorageFailure> {
        do {
            try storage.delete(key: userKey)
            return .success(true)
        } catch {
            return .failure(
                RemoveLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }

    func getBool(key: String) async -> Result<Bool, GetLocalStorageFailure> {
        do {
            guard let value = try storage.read(key: key) else {
                return .success(false)
            }
            return .success(value.lowercased() == "true")
        } catch {
            return .failure(
                GetLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }

    func setBool(key: String, value: Bool) async -> Result<
        Bool, SetLocalStorageFailure
    > {
        do {
            try storage.write(key: key, value: String(value))
            return .success(true)
        } catch {
            return .failure(
                SetLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }

    func deleteAll() async -> Result<Bool, RemoveLocalStorageFailure> {
        do {
            try storage.deleteAll()
            return .success(true)
        } catch {
            return .failure(
                RemoveLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }

    func containsKey(key: String) async -> Result<Bool, GetLocalStorageFailure>
    {
        do {
            return .success(try storage.containsKey(key: key))
        } catch {
            return .failure(
                GetLocalStorageFailure(error: error.localizedDescription)
            )
        }
    }
}
