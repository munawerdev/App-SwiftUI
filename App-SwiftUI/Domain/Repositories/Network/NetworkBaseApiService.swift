import Foundation

protocol NetworkBaseApiService {
    func execute<T: Decodable>(_ request: ApiRequest) async -> Result<
        T, NetworkFailure
    >
}

extension NetworkBaseApiService {

    func get<T: Decodable>(
        url: String,
        queryParams: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async -> Result<T, NetworkFailure> {
        await execute(
            ApiRequest(
                method: .get,
                url: url,
                queryParams: queryParams,
                headers: headers
            )
        )
    }

    func post<T: Decodable>(
        url: String,
        body: [String: Any],
        headers: [String: String]? = nil,
        queryParams: [String: Any]? = nil,
        isFormData: Bool = false,
        onSendProgress: (@Sendable (Int64, Int64) -> Void)? = nil
    ) async -> Result<T, NetworkFailure> {
        await execute(
            ApiRequest(
                method: .post,
                url: url,
                queryParams: queryParams,
                headers: headers,
                body: body,
                isFormData: isFormData,
                onSendProgress: onSendProgress
            )
        )
    }

    func patch<T: Decodable>(
        url: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil,
        queryParams: [String: Any]? = nil,
        isFormData: Bool = false,
        onSendProgress: (@Sendable (Int64, Int64) -> Void)? = nil
    ) async -> Result<T, NetworkFailure> {
        await execute(
            ApiRequest(
                method: .patch,
                url: url,
                queryParams: queryParams,
                headers: headers,
                body: body,
                isFormData: isFormData,
                onSendProgress: onSendProgress
            )
        )
    }

    func put<T: Decodable>(
        url: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil,
        queryParams: [String: Any]? = nil,
        isFormData: Bool = false,
        onSendProgress: (@Sendable (Int64, Int64) -> Void)? = nil
    ) async -> Result<T, NetworkFailure> {
        await execute(
            ApiRequest(
                method: .put,
                url: url,
                queryParams: queryParams,
                headers: headers,
                body: body,
                isFormData: isFormData,
                onSendProgress: onSendProgress
            )
        )
    }

    func delete<T: Decodable>(
        url: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async -> Result<T, NetworkFailure> {
        await execute(
            ApiRequest(method: .delete, url: url, headers: headers, body: body)
        )
    }

    func upload<T: Decodable>(
        url: String,
        filePath: String,
        fileName: String,
        data: [String: Any]? = nil,
        headers: [String: String]? = nil,
        onSendProgress: (@Sendable (Int64, Int64) -> Void)? = nil
    ) async -> Result<T, NetworkFailure> {
        await execute(
            ApiRequest(
                method: .post,
                url: url,
                headers: headers,
                body: data,
                file: UploadFile(filePath: filePath, fileName: fileName),
                onSendProgress: onSendProgress
            )
        )
    }
}
