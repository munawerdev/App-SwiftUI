import SwiftUI

extension ApiResponse {
    func toView<Content: View>(
        onLoading: (() -> AnyView)? = nil,
        onError: ((NetworkFailure) -> AnyView)? = nil,
        onRetry: (() -> Void)? = nil,
        config: StatusSwitcherConfig = StatusSwitcherConfig(),
        customErrorTitle: String? = nil,
        customNoDataTitle: String? = nil,
        customNoDataSubtitle: String? = nil,
        @ViewBuilder onCompleted: @escaping (T) -> Content
    ) -> some View {
        StatusSwitcher(
            response: self,
            onLoading: onLoading,
            onError: onError,
            onRetry: onRetry,
            config: config,
            customErrorTitle: customErrorTitle,
            customNoDataTitle: customNoDataTitle,
            customNoDataSubtitle: customNoDataSubtitle,
            onCompleted: onCompleted
        )
    }
}
