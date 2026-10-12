import SwiftUI

struct StatusSwitcher<T, Content: View>: View {
    let response: ApiResponse<T>
    var onLoading: (() -> AnyView)?
    var onError: ((NetworkFailure) -> AnyView)?
    var onRetry: (() -> Void)?
    var config: StatusSwitcherConfig
    var customErrorTitle: String?
    var customNoDataTitle: String?
    var customNoDataSubtitle: String?
    let onCompleted: (T) -> Content

    init(
        response: ApiResponse<T>,
        onLoading: (() -> AnyView)? = nil,
        onError: ((NetworkFailure) -> AnyView)? = nil,
        onRetry: (() -> Void)? = nil,
        config: StatusSwitcherConfig = StatusSwitcherConfig(),
        customErrorTitle: String? = nil,
        customNoDataTitle: String? = nil,
        customNoDataSubtitle: String? = nil,
        @ViewBuilder onCompleted: @escaping (T) -> Content
    ) {
        self.response = response
        self.onLoading = onLoading
        self.onError = onError
        self.onRetry = onRetry
        self.config = config
        self.customErrorTitle = customErrorTitle
        self.customNoDataTitle = customNoDataTitle
        self.customNoDataSubtitle = customNoDataSubtitle
        self.onCompleted = onCompleted
    }

    var body: some View {
        switch response {
        case .initial:
            EmptyView()  // SizedBox.shrink()

        case .loading:
            if let onLoading {
                onLoading()
            } else {
                DefaultLoadingView()
            }

        case .error(let failure):
            if let onError {
                onError(failure)
            } else {
                DefaultErrorView(
                    failure: failure,
                    onRetry: onRetry,
                    config: config,
                    customTitle: customErrorTitle
                )
            }

        case .completed(let data):
            if isDataEmpty(data) {
                DefaultNoDataView(
                    config: config,
                    title: customNoDataTitle,
                    subtitle: customNoDataSubtitle
                )
            } else {
                onCompleted(data)
            }
        }
    }

    private func isDataEmpty(_ data: T) -> Bool {
        // nil optional
        let mirror = Mirror(reflecting: data)
        if mirror.displayStyle == .optional && mirror.children.isEmpty {
            return true
        }

        // Array, Set, Dictionary, String are all Collections
        if let collection = data as? any Collection {
            return collection.isEmpty
        }

        return false
    }
}
