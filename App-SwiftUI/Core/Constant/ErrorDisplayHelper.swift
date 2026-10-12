import SwiftUI

struct ErrorDisplayProperties {
    let icon: String  // SF Symbol name
    let color: Color
    let title: String
}

enum ErrorDisplayHelper {
    static func displayProperties(for failure: NetworkFailure)
        -> ErrorDisplayProperties
    {
        switch failure.type {
        case .noInternetConnection:
            return .init(
                icon: "wifi.slash",
                color: .orange,
                title: "No Internet Connection"
            )
        case .connectionTimeout, .sendTimeout, .receiveTimeout:
            return .init(
                icon: "clock.badge.exclamationmark",
                color: .orange,
                title: "Request Timed Out"
            )
        case .unauthorized:
            return .init(icon: "lock.fill", color: .red, title: "Unauthorized")
        case .forbidden:
            return .init(
                icon: "hand.raised.fill",
                color: .red,
                title: "Access Denied"
            )
        case .notFound:
            return .init(
                icon: "magnifyingglass",
                color: .gray,
                title: "Not Found"
            )
        case .badRequest, .validationError:
            return .init(
                icon: "exclamationmark.triangle.fill",
                color: .yellow,
                title: "Invalid Request"
            )
        case .tooManyRequests:
            return .init(
                icon: "hourglass",
                color: .orange,
                title: "Too Many Requests"
            )
        case .internalServerError, .badGateway, .serviceUnavailable,
            .badResponse:
            return .init(
                icon: "server.rack",
                color: .red,
                title: "Server Error"
            )
        case .formatError:
            return .init(
                icon: "doc.text.magnifyingglass",
                color: .red,
                title: "Unexpected Response"
            )
        case .cancelled:
            return .init(
                icon: "xmark.circle",
                color: .gray,
                title: "Request Cancelled"
            )
        case .unknown:
            return .init(
                icon: "exclamationmark.circle.fill",
                color: .red,
                title: "Something Went Wrong"
            )
        }
    }
}
