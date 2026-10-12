// HomeState.swift
struct HomeState {
    var response: ApiResponse<HomeModel>

    static func initial(initialParams: HomeInitialParams) -> HomeState {
        HomeState(response: .initial(HomeModel()))
    }
}
