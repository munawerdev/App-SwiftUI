import SwiftUI

struct DefaultErrorView: View {
    let failure: NetworkFailure
    var onRetry: (() -> Void)?
    var config: StatusSwitcherConfig
    var customTitle: String?

    @State private var appeared = false

    private var props: ErrorDisplayProperties {
        ErrorDisplayHelper.displayProperties(for: failure)
    }

    private var shouldShowRetry: Bool {
        config.showRetryButton && onRetry != nil
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 0) {
                    errorIcon
                        .padding(.bottom, 24)

                    if let code = failure.statusCode {
                        statusBadge(code)
                            .padding(.bottom, 12)
                    }

                    Text(customTitle ?? props.title)
                        .font(.title3.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)

                    errorMessage

                    if shouldShowRetry, let onRetry {
                        AppButton(
                            title: config.retryButtonText,
                            action: onRetry
                        )
                        .padding(.top, 32)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)  // centers vertically
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { appeared = true }
        }
    }

    private var errorIcon: some View {
        Image(systemName: props.icon)
            .font(.system(size: 36))
            .foregroundStyle(props.color)
            .padding(20)
            .background(Circle().fill(props.color.opacity(0.1)))
            .overlay(Circle().stroke(props.color.opacity(0.3), lineWidth: 2))
    }

    private func statusBadge(_ code: Int) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .font(.system(size: 14))
                .foregroundStyle(props.color)
            Text("Error \(code)")
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Capsule().fill(props.color.opacity(0.15)))
        .overlay(Capsule().stroke(props.color.opacity(0.3), lineWidth: 1))
    }

    private var errorMessage: some View {
        Text(failure.error)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
            )
    }
}
