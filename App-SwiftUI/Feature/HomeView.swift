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
        Text("Details for: \(item)")
            .navigationTitle(item)
    }
}
