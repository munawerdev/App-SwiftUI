import SwiftUI

struct HomeView: View {
    @Environment(\.container) private var container

    var body: some View {
        if let container {
            HomeContentView(viewModel: container.makeHomeViewModel())
        }
    }
}

private struct HomeContentView: View {
    @State private var viewModel: HomeViewModel
    // @Environment(Router.self) private var router   // use router.push(...) when you need to navigate

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        viewModel.state.response.toView(
            onRetry: { Task { await viewModel.home(showLoading: true) } }
        ) { data in
            // Replace EmptyView with your real home content
            ScrollView {
                EmptyView()
            }
            .refreshable { await viewModel.home() }
        }
        .task { await viewModel.home() }
    }
}

#Preview {
    AppNavigationStack {
        HomeView()
    }
    .environment(\.container, AppContainer())
}
