import SwiftUI

struct DefaultNoDataView: View {
    let config: StatusSwitcherConfig
    var title: String?
    var subtitle: String?

    var body: some View {
        VStack(spacing: 11) {
            Text(title ?? config.defaultNoDataTitle)
                .font(.headline)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
