import SwiftUI

struct AppButton: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void

    // Customization with defaults
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var height: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var horizontalPadding: CGFloat

    // MARK: - Init
    init(
        title: String,
        fontSize: CGFloat = 17,
        fontWeight: Font.Weight = .semibold,
        height: CGFloat = 70,
        cornerRadius: CGFloat = 30,
        backgroundColor: Color = Color("ButtonTextColor"),
        foregroundColor: Color = Color("OnboardingBackgroundColor"),
        horizontalPadding: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.horizontalPadding = horizontalPadding
        self.action = action
    }

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: fontWeight, design: .rounded))
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(backgroundColor)
                .clipShape(.rect(cornerRadius: cornerRadius))
        }
        .padding(.horizontal, horizontalPadding)
    }
}
