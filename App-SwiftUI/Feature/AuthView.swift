import SwiftUI

struct AuthView: View {
    @State private var viewModel: AuthViewModel
    @Environment(Router.self) private var router

    init(viewModel: AuthViewModel = AuthViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                logoSection

                AppTextField(
                    title: "Email",
                    text: $viewModel.email,
                    keyboardType: .emailAddress,
                    contentType: .emailAddress,
                    capitalization: .never
                )

                AppSecureField(
                    title: "Password",
                    text: $viewModel.password
                )

                Spacer()

                AppButton(
                    title: "Login",
                    backgroundColor: AppColors.primary,
                    foregroundColor: Color("ButtonTextColor")
                ) {
                    // Demo navigation only.
                    // Replace this with successful login handling.
                    router.push(.bottomNavBar)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private var logoSection: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 162)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(.white)
            .clipShape(.rect(cornerRadius: 30))
            .shadow(
                color: .black.opacity(0.05),
                radius: 10,
                x: 0,
                y: 10
            )
    }
}

#Preview() {
    let container = AppContainer()

    AppNavigationStack(container: container) {
        AuthView()
    }

}
