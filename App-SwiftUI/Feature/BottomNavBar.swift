import SwiftUI

// MARK: - Tab model

enum AppTab: Int, CaseIterable, Identifiable {
    case home, favorite, profile, history

    var id: Self { self }

    var title: String {
        switch self {
        case .home:     "Home"
        case .favorite: "Favorites"
        case .profile:  "Profile"
        case .history:  "History"
        }
    }

    /// Returns the filled variant when selected, if the symbol has one.
    func icon(isSelected: Bool) -> String {
        switch self {
        case .home:     isSelected ? "house.fill" : "house"
        case .favorite: isSelected ? "heart.fill" : "heart"
        case .profile:  isSelected ? "person.fill" : "person"
        case .history:  "clock.arrow.circlepath"
        }
    }
}

// MARK: - Container

struct BottomNavBar: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background.ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 0) {
                CustomBottomBar(selectedTab: $selectedTab)
            }
            .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .home:     HomeView(title: "Hello Home")
        case .favorite: FavoriteView()
        case .profile:  Text("Profile View")   // replace with ProfileView()
        case .history:  Text("History View")   // replace with HistoryView()
        }
    }
}

// MARK: - Bar

struct CustomBottomBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
                .frame(maxWidth: .infinity)   // even spacing, replaces Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .background(
            AppColors.background
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Item

struct TabBarItem: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: tab.icon(isSelected: isSelected))
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(isSelected ? AppColors.primary : .gray.opacity(0.5))
                .shadow(
                    color: isSelected ? AppColors.primary.opacity(0.6) : .clear,
                    radius: 6, x: 0, y: 4
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .frame(maxWidth: .infinity, minHeight: 44)  // 44pt min tap target
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    AppNavigationStack {
        BottomNavBar()
    }
}
