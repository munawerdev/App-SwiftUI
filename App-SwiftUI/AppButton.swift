import SwiftUI

struct AppButton<Destination: View>: View {
    // MARK: - Properties
    let title: String
    let destination: Destination

    // Customization with defaults
    var fontSize: CGFloat = 17
    var fontWeight: Font.Weight = .semibold
    var height: CGFloat = 70
    var cornerRadius: CGFloat = 30
    var backgroundColor: Color = Color("ButtonTextColor")
    var foregroundColor: Color = Color("OnboardingBackgroundColor")
    var horizontalPadding: CGFloat = 50

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
        @ViewBuilder destination: () -> Destination
    ) {
        self.title = title
        self.destination = destination()
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.horizontalPadding = horizontalPadding
    }

    // MARK: - Body
    var body: some View {
        NavigationLink {
            destination
        } label: {
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
