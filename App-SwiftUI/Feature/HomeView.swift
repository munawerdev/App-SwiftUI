import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router

    var body: some View {
        Button("Open detail") { router.push(.detail(item: "Hello Navigation")) }
    }
}

#Preview {
    HomeView()
}

struct DetailView: View {
    
    let item: String
    var body: some View {
        Text("Details for: \(item)")
            .navigationTitle(item)
    }
}
