import SwiftUI

enum AppSize {
    static let radius: CGFloat = 8
    static let buttonHeight: CGFloat = 48
    static let padding: CGFloat = 16
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: AppSize.buttonHeight)
            .background(AppColors.primary, in: .rect(cornerRadius: AppSize.radius))
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.4)
    }
}

struct OutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity, minHeight: AppSize.buttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: AppSize.radius)
                    .stroke(AppColors.primary, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// Text field look: use as .appField()
extension View {
    func appField() -> some View {
        self
            .padding(.horizontal, AppSize.padding)
            .frame(minHeight: AppSize.buttonHeight)
//            .background(AppColors.surface, in: .rect(cornerRadius: AppSize.radius))
//            .overlay(
//                RoundedRectangle(cornerRadius: AppSize.radius)
//                    .stroke(AppColors.border, lineWidth: 1)
//            )
    }
}
