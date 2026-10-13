import Foundation

nonisolated struct UserInfoStoreModel: Codable, Equatable {
    let accessToken: String
    let refreshToken: String

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    // factory UserInfoStoreModel.empty()
    static let empty = UserInfoStoreModel(accessToken: "", refreshToken: "")

    // copyWith
    func copyWith(accessToken: String? = nil, refreshToken: String? = nil)
        -> UserInfoStoreModel
    {
        UserInfoStoreModel(
            accessToken: accessToken ?? self.accessToken,
            refreshToken: refreshToken ?? self.refreshToken
        )
    }

    // fromJson: missing or null keys fall back to '' like `json['x'] ?? ''`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken =
            try container.decodeIfPresent(String.self, forKey: .accessToken)
            ?? ""
        refreshToken =
            try container.decodeIfPresent(String.self, forKey: .refreshToken)
            ?? ""
    }

    // toJson is generated automatically by Codable's encode(to:)
}

extension UserInfoStoreModel {
    init(json: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: json)
        self = try JSONDecoder().decode(UserInfoStoreModel.self, from: data)
    }
}
