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

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        viewModel.state.response.toView(
            onRetry: { Task { await viewModel.home(showLoading: true) } }
        ) { data in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(data.products) { product in
                        ProductRow(product: product)
                    }
                }
                .padding()
            }
            .refreshable { await viewModel.home() }
        }
        .task { await viewModel.home() }
    }
}

private struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(product.category.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(product.price.formatted(.currency(code: "USD")))
                    .font(.subheadline.weight(.semibold))
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(
                Color.secondary.opacity(0.08)
            )
        )
    }
}

#Preview {
    AppNavigationStack {
        HomeView()
    }
    .environment(\.container, AppContainer())
}
