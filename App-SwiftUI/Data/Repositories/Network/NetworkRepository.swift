import Foundation
import UniformTypeIdentifiers

final class NetworkRepository: NetworkBaseApiService {
    private let session: URLSession
    private let userDataSources: UserDataSources
    private let errorHandler: ApiErrorHandler
    private let tokenRefresher: TokenRefresher
    private let decoder: JSONDecoder

    init(
        userDataSources: UserDataSources,
        localStorageRepository: LocalStorageBaseApiService,
        errorHandler: ApiErrorHandler = ApiErrorHandler(),
        session: URLSession = NetworkConfig.makeSession(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDataSources = userDataSources
        self.errorHandler = errorHandler
        self.session = session
        self.decoder = decoder
        self.tokenRefresher = TokenRefresher(
            userDataSources: userDataSources,
            localStorageRepository: localStorageRepository,
            session: session
        )
    }

    // MARK: - Core (replaces _executeRequest + AuthInterceptor.onRequest/onError)

    func execute<T: Decodable>(_ request: ApiRequest) async -> Result<
        T, NetworkFailure
    > {
        do {
            var prepared = try prepare(request)

            // onRequest: attach the access token
            let token = userDataSources.state.accessToken
            if !token.isEmpty {
                prepared.request.setValue(
                    "Bearer \(token)",
                    forHTTPHeaderField: "Authorization"
                )
            }

            var (data, response) = try await send(
                prepared,
                onProgress: request.onSendProgress
            )

            // onError: on 401, refresh once and retry once
            if response.statusCode == 401,
                let newToken = await tokenRefresher.validToken(),
                !newToken.isEmpty
            {
                prepared.request.setValue(
                    "Bearer \(newToken)",
                    forHTTPHeaderField: "Authorization"
                )
                if let retried = try? await send(
                    prepared,
                    onProgress: request.onSendProgress
                ) {
                    (data, response) = retried
                }
            }

            guard (200..<300).contains(response.statusCode) else {
                return .failure(
                    errorHandler.handleBadResponse(
                        statusCode: response.statusCode,
                        data: data
                    )
                )
            }

            return decode(data)
        } catch {
            return .failure(errorHandler.handle(error))
        }
    }

    // MARK: - Helpers

    private struct PreparedRequest {
        var request: URLRequest
        var body: Data?
    }

    private func send(
        _ prepared: PreparedRequest,
        onProgress: (@Sendable (Int64, Int64) -> Void)?
    ) async throws -> (Data, HTTPURLResponse) {
        let delegate = onProgress.map { ProgressDelegate(onProgress: $0) }

        let result: (Data, URLResponse)
        if let body = prepared.body {
            result = try await session.upload(
                for: prepared.request,
                from: body,
                delegate: delegate
            )
        } else {
            result = try await session.data(
                for: prepared.request,
                delegate: delegate
            )
        }

        guard let http = result.1 as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return (result.0, http)
    }

    private func decode<T: Decodable>(_ data: Data) -> Result<T, NetworkFailure>
    {
        if data.isEmpty, T.self == EmptyResponse.self,
            let empty = EmptyResponse() as? T
        {
            return .success(empty)
        }
        do {
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            return .failure(errorHandler.handle(error))
        }
    }

    private func prepare(_ r: ApiRequest) throws -> PreparedRequest {
        guard var components = URLComponents(string: r.url) else {
            throw RequestBuildError.invalidURL(r.url)
        }

        if let params = r.queryParams, !params.isEmpty {
            var items = components.queryItems ?? []
            for (key, value) in params.sorted(by: { $0.key < $1.key }) {
                if value is NSNull { continue }
                if let list = value as? [Any] {
                    items += list.map {
                        URLQueryItem(name: key, value: "\($0)")
                    }
                } else {
                    items.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            components.queryItems = items
        }

        guard let url = components.url else {
            throw RequestBuildError.invalidURL(r.url)
        }

        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        r.headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        var body: Data?

        if let file = r.file {
            var form = MultipartFormData()
            do {
                let fileData = try Data(
                    contentsOf: URL(fileURLWithPath: file.filePath)
                )
                form.addFile(
                    name: "file",
                    fileName: file.fileName,
                    mimeType: mimeType(for: file.fileName),
                    fileData: fileData
                )
            } catch {
                throw RequestBuildError.uploadPreparation(
                    error.localizedDescription
                )
            }
            r.body?.forEach {
                form.addField(name: $0.key, value: "\($0.value)")
            }
            body = form.body
            request.setValue(
                form.contentType,
                forHTTPHeaderField: "Content-Type"
            )

        } else if r.isFormData, let fields = r.body {
            var form = MultipartFormData()
            fields.forEach { form.addField(name: $0.key, value: "\($0.value)") }
            body = form.body
            request.setValue(
                form.contentType,
                forHTTPHeaderField: "Content-Type"
            )

        } else if let json = r.body {
            body = try JSONSerialization.data(withJSONObject: json)
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        return PreparedRequest(request: request, body: body)
    }

    private func mimeType(for fileName: String) -> String {
        let ext = URL(fileURLWithPath: fileName).pathExtension
        return UTType(filenameExtension: ext)?.preferredMIMEType
            ?? "application/octet-stream"
    }
}
