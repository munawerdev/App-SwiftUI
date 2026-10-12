import Foundation
import os

/// Only one refresh request runs at a time. Concurrent callers that hit a 401
/// await the same Task, which replaces the Dart `_pendingTokenRefresh` completers.
actor TokenRefresher {
    private let userDataSources: UserDataSources
    private let localStorageRepository: LocalStorageBaseApiService
    private let session: URLSession
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "app",
        category: "Auth"
    )

    private var inFlight: Task<String?, Never>?

    init(
        userDataSources: UserDataSources,
        localStorageRepository: LocalStorageBaseApiService,
        session: URLSession
    ) {
        self.userDataSources = userDataSources
        self.localStorageRepository = localStorageRepository
        self.session = session
    }

    /// Returns a fresh access token, or nil if refreshing failed.
    func validToken() async -> String? {
        if let task = inFlight {
            return await task.value
        }
        let task = Task { await self.performRefresh() }
        inFlight = task
        let token = await task.value
        inFlight = nil
        return token
    }

    private func performRefresh() async -> String? {
        let refreshToken = await userDataSources.state.refreshToken
        guard !refreshToken.isEmpty else {
            logger.error("No refresh token available")
            return nil
        }

        do {
            guard let url = URL(string: AppUrl.refreshToken) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            let body = try JSONSerialization.data(withJSONObject: [
                "refreshToken": refreshToken
            ])

            // Uses its own request path, so no auth header and no recursion
            let (data, response) = try await session.upload(
                for: request,
                from: body
            )

            guard let http = response as? HTTPURLResponse,
                http.statusCode == 200
            else {
                logger.error("Failed to refresh token")
                return nil
            }

            let newUser = try JSONDecoder().decode(
                UserInfoStoreModel.self,
                from: data
            )
            guard !newUser.accessToken.isEmpty else {
                logger.error("Refresh response did not contain an access token")
                return nil
            }

            // Persist and update the in-memory session
            switch await localStorageRepository.setUserData(
                userInfoStoreModel: newUser
            ) {
            case .success:
                await userDataSources.setUserDataSources(
                    userInfoStoreModel: newUser
                )
            case .failure(let failure):
                logger.error("Failed to save user data: \(failure.error)")
            }

            return newUser.accessToken
        } catch {
            logger.error("Token refresh failed: \(error.localizedDescription)")
            return nil
        }
    }
}
