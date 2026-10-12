import Foundation

struct ApiErrorHandler {
    init() {}

    // MARK: - Thrown errors (Dio's DioException types)

    func handle(_ error: Error) -> NetworkFailure {
        switch error {
        case let e as URLError:
            return handleURLError(e)
        case is CancellationError:
            return NetworkFailure(
                error: "Request was cancelled",
                type: .cancelled
            )
        case is DecodingError:
            return NetworkFailure(
                error: "Invalid response format from server.",
                type: .formatError
            )
        case RequestBuildError.invalidURL(let url):
            return NetworkFailure(error: "Invalid URL: \(url)", type: .unknown)
        case RequestBuildError.uploadPreparation(let message):
            return NetworkFailure(
                error: "File upload preparation failed: \(message)",
                type: .unknown
            )
        default:
            return NetworkFailure(
                error: "Unexpected error: \(error.localizedDescription)",
                type: .unknown
            )
        }
    }

    private func handleURLError(_ e: URLError) -> NetworkFailure {
        switch e.code {
        case .timedOut:
            // URLSession doesn't tell connect/send/receive timeouts apart
            return NetworkFailure(
                error:
                    "Connection timeout. Please check your internet connection.",
                type: .connectionTimeout
            )
        case .cancelled:
            return NetworkFailure(
                error: "Request was cancelled",
                type: .cancelled
            )
        case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost,
            .cannotConnectToHost, .dnsLookupFailed, .dataNotAllowed,
            .internationalRoamingOff:
            return NetworkFailure(
                error: "No internet connection. Please check your network.",
                type: .noInternetConnection
            )
        case .secureConnectionFailed, .serverCertificateHasBadDate,
            .serverCertificateUntrusted,
            .serverCertificateHasUnknownRoot, .serverCertificateNotYetValid,
            .clientCertificateRejected, .clientCertificateRequired:
            return NetworkFailure(
                error:
                    "SSL certificate error. Please check your connection security.",
                type: .unknown
            )
        case .badServerResponse, .cannotParseResponse, .cannotDecodeContentData,
            .cannotDecodeRawData, .zeroByteResource:
            return NetworkFailure(
                error: "Bad response from server.",
                type: .badResponse
            )
        default:
            return NetworkFailure(
                error: "Unknown network error: \(e.localizedDescription)",
                type: .unknown
            )
        }
    }

    // MARK: - HTTP status codes (Dio's badResponse)

    func handleBadResponse(statusCode: Int, data: Data) -> NetworkFailure {
        let body = parseJSON(data)
        let message = extractErrorMessage(body)
        let extra = normalizeAdditionalData(body)

        func fail(_ error: String, _ type: NetworkFailureType) -> NetworkFailure
        {
            NetworkFailure(
                error: error,
                type: type,
                statusCode: statusCode,
                additionalData: extra
            )
        }
        func prefixed(_ prefix: String, fallback: String) -> String {
            message.isEmpty ? fallback : "\(prefix): \(message)"
        }
        func orFallback(_ fallback: String) -> String {
            message.isEmpty ? fallback : message
        }

        switch statusCode {
        case 400:
            return fail(
                prefixed(
                    "Bad request",
                    fallback: "Bad request. Please check your input."
                ),
                .badRequest
            )
        case 401:
            return fail(
                orFallback("Unauthorized access. Please login again."),
                .unauthorized
            )
        case 403:
            return fail(
                orFallback("Access forbidden. You don't have permission."),
                .forbidden
            )
        case 404: return fail(orFallback("Resource not found"), .notFound)
        case 408:
            return fail(
                "Request timeout. Please try again.",
                .connectionTimeout
            )
        case 409:
            return fail(
                prefixed(
                    "Conflict",
                    fallback:
                        "Resource conflict. The request conflicts with the current state."
                ),
                .badRequest
            )
        case 410: return fail("Resource is no longer available.", .notFound)
        case 413:
            return fail(
                "Request entity too large. Please reduce the size of your request.",
                .badRequest
            )
        case 414: return fail("Request URI too long.", .badRequest)
        case 415: return fail("Unsupported media type.", .badRequest)
        case 422:
            return fail(
                prefixed(
                    "Validation error",
                    fallback: "Validation error. Please check your input."
                ),
                .validationError
            )
        case 423: return fail("Resource is locked.", .forbidden)
        case 424: return fail("Failed dependency.", .badRequest)
        case 428:
            return fail(
                prefixed(
                    "Precondition required",
                    fallback: "Precondition required."
                ),
                .badRequest
            )
        case 429:
            return fail(
                orFallback("Too many requests. Please try again later."),
                .tooManyRequests
            )
        case 431: return fail("Request header fields too large.", .badRequest)
        case 500:
            return fail(
                prefixed(
                    "Server error",
                    fallback: "Internal server error. Please try again later."
                ),
                .internalServerError
            )
        case 501:
            return fail(
                "Not implemented. The server does not support this operation.",
                .badResponse
            )
        case 502:
            return fail(
                "Bad gateway. Server is temporarily unavailable.",
                .badGateway
            )
        case 503:
            return fail(
                orFallback("Service unavailable. Please try again later."),
                .serviceUnavailable
            )
        case 504:
            return fail(
                "Gateway timeout. The server did not receive a timely response.",
                .badGateway
            )
        case 505: return fail("HTTP version not supported.", .badResponse)
        case 507: return fail("Insufficient storage.", .internalServerError)
        case 508: return fail("Loop detected.", .badResponse)
        case 510: return fail("Not extended.", .badResponse)
        case 511: return fail("Network authentication required.", .unauthorized)
        case 400..<500:
            return fail(orFallback("Client error occurred"), .badRequest)
        case 500...:
            return fail(
                orFallback("Server error occurred"),
                .internalServerError
            )
        default: return fail(orFallback("Request failed"), .badResponse)
        }
    }

    // MARK: - Response parsing helpers

    private func parseJSON(_ data: Data) -> Any? {
        guard !data.isEmpty else { return nil }
        if let object = try? JSONSerialization.jsonObject(
            with: data,
            options: [.fragmentsAllowed]
        ),
            !(object is NSNull)
        {
            return object
        }
        return String(data: data, encoding: .utf8)
    }

    private func extractErrorMessage(_ value: Any?) -> String {
        guard let value, !(value is NSNull) else { return "" }

        if let string = value as? String {
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if let dict = value as? [String: Any] {
            let keys = [
                "message", "error", "error_message", "msg", "detail",
                "details", "description", "reason", "status_message",
            ]
            for key in keys {
                if let message = dict[key], !(message is NSNull) {
                    if let string = message as? String { return string }
                    if let list = message as? [Any] {
                        return list.map { "\($0)" }.joined(separator: ", ")
                    }
                    return "\(message)"
                }
            }
            if let errors = dict["errors"], !(errors is NSNull) {
                return extractErrors(errors)
            }
            if let validation = dict["validation"], !(validation is NSNull) {
                return extractErrors(validation)
            }
            return dict.isEmpty ? "" : "\(dict)"
        }

        if let list = value as? [Any] {
            return list.map { "\($0)" }.joined(separator: ", ")
        }

        return "\(value)"
    }

    private func extractErrors(_ errors: Any) -> String {
        if let string = errors as? String { return string }
        if let list = errors as? [Any] {
            return list.map { "\($0)" }.joined(separator: ", ")
        }
        if let dict = errors as? [String: Any] {
            return dict.sorted { $0.key < $1.key }.map { entry -> String in
                if let list = entry.value as? [Any] {
                    return
                        "\(entry.key): \(list.map { "\($0)" }.joined(separator: ", "))"
                }
                if let nested = entry.value as? [String: Any] {
                    return "\(entry.key): \(extractErrors(nested))"
                }
                return "\(entry.key): \(entry.value)"
            }.joined(separator: "; ")
        }
        return "\(errors)"
    }

    private func normalizeAdditionalData(_ value: Any?) -> [String: Any]? {
        guard let value, !(value is NSNull) else { return nil }
        if let dict = value as? [String: Any] { return dict }
        if let string = value as? String { return ["raw": string] }
        if let list = value as? [Any] { return ["items": list] }
        return ["data": "\(value)"]
    }
}
