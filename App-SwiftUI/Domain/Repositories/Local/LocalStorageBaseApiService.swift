protocol LocalStorageBaseApiService {
    func setUserData(userInfoStoreModel: UserInfoStoreModel) async -> Result<
        Bool, SetLocalStorageFailure
    >
    func getUserData() async -> Result<
        UserInfoStoreModel, GetLocalStorageFailure
    >
    func removeUserData() async -> Result<Bool, RemoveLocalStorageFailure>

    func setBool(key: String, value: Bool) async -> Result<
        Bool, SetLocalStorageFailure
    >
    func getBool(key: String) async -> Result<Bool, GetLocalStorageFailure>

    func deleteAll() async -> Result<Bool, RemoveLocalStorageFailure>
    func containsKey(key: String) async -> Result<Bool, GetLocalStorageFailure>
}
