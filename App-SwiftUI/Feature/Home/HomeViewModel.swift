import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var state: HomeState

    private let networkRepository: NetworkBaseApiService
    let initialParams: HomeInitialParams

    init(
        initialParams: HomeInitialParams,
        networkRepository: NetworkBaseApiService
    ) {
        self.initialParams = initialParams
        self.networkRepository = networkRepository
        self.state = .initial(initialParams: initialParams)
    }

    func home(showLoading: Bool = false) async {
        if showLoading {
            state.response = .loading
        }

        let result: Result<HomeModel, NetworkFailure> =
            await networkRepository.get(url: AppUrl.home)

        switch result {
        case .failure(let failure):
            state.response = .error(failure)
        case .success(let model):
            state.response = .completed(model)
        }
    }
}
