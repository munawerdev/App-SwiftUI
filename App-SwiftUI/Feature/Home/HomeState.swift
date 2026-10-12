// HomeState.swift
struct HomeState {
    var response: ApiResponse<HomeModel>

    static func initial(initialParams: HomeInitialParams) -> HomeState {
        // HomeView starts loading as soon as it appears. Keep the first frame
        // visible while that request is in flight instead of rendering EmptyView.
        HomeState(response: .loading)
    }
}
