import Foundation

struct LoginModel: Encodable {
    var email: String
    var password: String
}
// toJson() is automatic: try JSONEncoder().encode(loginModel)
