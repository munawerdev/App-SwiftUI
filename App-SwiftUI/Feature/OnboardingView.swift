import SwiftUI

struct OnboardingView: View {
    @Environment(Router.self) private var router

    private let gradientColor = Color(
        red: 255 / 255,
        green: 71 / 255,
        blue: 11 / 255
    )

    var body: some View {

        ZStack(alignment: .topLeading) {
            AppColors.primary
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 73, height: 73)
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 50)
                }.padding(.horizontal, 50)

                VStack(alignment: .leading, spacing: -15) {
                    Text("Food for")
                    Text("Everyone")
                }.padding(.horizontal, 50)
                    .foregroundStyle(.white)
                    .font(
                        .system(size: 65, weight: .heavy, design: .rounded)
                    )
                    .tracking(-3)

                Spacer()

                VStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        Image("OnboardingBackground2")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.7)
                            .offset(x: 110, y: 30)

                        Image("OnboardingBackground1")
                            .resizable()
                            .scaledToFit()
                            .offset(x: -70, y: 0)
                    }
                    .overlay(
                        // Linear gradient from 10% clear to 100% #FF470B
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.10),
                                .init(color: gradientColor, location: 1.00),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    AppButton(title: "Get Started") {
                        router.push(.auth)
                    }
                }
            }
            .padding(.top, 20)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}

#Preview {
    AppNavigationStack {
        OnboardingView()
    }
}
