import Foundation

nonisolated enum NetworkFailureType {
    case connectionTimeout
    case sendTimeout
    case receiveTimeout
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case validationError
    case tooManyRequests
    case internalServerError
    case badGateway
    case serviceUnavailable
    case badResponse
    case cancelled
    case noInternetConnection
    case formatError
    case unknown
}

nonisolated struct NetworkFailure: Error, Hashable, CustomStringConvertible {
    let error: String
    let type: NetworkFailureType
    let statusCode: Int?
    let additionalData: [String: Any]?

    init(
        error: String,
        type: NetworkFailureType = .unknown,
        statusCode: Int? = nil,
        additionalData: [String: Any]? = nil
    ) {
        self.error = error
        self.type = type
        self.statusCode = statusCode
        self.additionalData = additionalData
    }

    var description: String {
        "NetworkFailure(error: \(error), type: \(type), statusCode: \(statusCode.map(String.init) ?? "nil"))"
    }

    // Like the Dart version, additionalData is ignored in == and hash
    static func == (lhs: NetworkFailure, rhs: NetworkFailure) -> Bool {
        lhs.error == rhs.error && lhs.type == rhs.type
            && lhs.statusCode == rhs.statusCode
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(error)
        hasher.combine(type)
        hasher.combine(statusCode)
    }
}
