import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct UploadFile {
    let filePath: String
    let fileName: String
}

struct ApiRequest {
    var method: HTTPMethod
    var url: String
    var queryParams: [String: Any]? = nil
    var headers: [String: String]? = nil
    var body: [String: Any]? = nil
    var isFormData = false
    var file: UploadFile? = nil
    var onSendProgress: (@Sendable (Int64, Int64) -> Void)? = nil
}

/// Use as T when the response has no body or you don't care about it.
struct EmptyResponse: Decodable {
    init() {}
    init(from decoder: Decoder) throws {}
}

enum RequestBuildError: Error {
    case invalidURL(String)
    case uploadPreparation(String)
}
