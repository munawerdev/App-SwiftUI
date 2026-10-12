import Foundation

enum NetworkConfig {
    static func makeSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30  // idle time between data packets
        config.timeoutIntervalForResource = 120  // total time, leaves room for uploads
        return URLSession(configuration: config)
    }
}
