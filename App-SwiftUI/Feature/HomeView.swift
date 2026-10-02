import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router

    var body: some View {
        Button("Open detail") { router.push(.detail(item: "Hello Navigation")) }
    }
}

#Preview {
    AppNavigationStack { HomeView() }
}

struct DetailView: View {
    @Environment(Router.self) private var router

    let item: String
    var body: some View {
        Button("Details for: \(item)") {
            router.push(.test)
        }
    }
}

struct TestView: View {
    @Environment(Router.self) private var router

    var body: some View {
        Button("test view") {
            router.pop(to: .bottomNavBar)
        }
    }
}
