import SwiftUI

struct HomeView: View {
    @Environment(Router.self) private var router

    @State private var searchText: String = ""
    @State private var selectedCategory: String = "Foods"

    private let categories = ["Foods", "Drinks", "Snacks", "Sauce"]

    private let foodItems: [FoodItem] = [
        FoodItem(
            id: "1",
            name: "Veggie\ntomato mix",
            price: "N1,900",
            category: "Foods",
            imageUrl:
                "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80"
        ),
        FoodItem(
            id: "2",
            name: "Spicy fish\nsauce",
            price: "N2,300",
            category: "Foods",
            imageUrl:
                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80"
        ),
        FoodItem(
            id: "3",
            name: "Egg & plantain\nfry",
            price: "N1,800",
            category: "Foods",
            imageUrl:
                "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80"
        ),
        FoodItem(
            id: "4",
            name: "Fresh fruit\njuice",
            price: "N1,200",
            category: "Drinks",
            imageUrl:
                "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=600&q=80"
        ),
        FoodItem(
            id: "5",
            name: "Iced lemon\ntea",
            price: "N900",
            category: "Drinks",
            imageUrl:
                "https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=600&q=80"
        ),
        FoodItem(
            id: "6",
            name: "Crunchy snack\nmix",
            price: "N800",
            category: "Snacks",
            imageUrl:
                "https://images.unsplash.com/photo-1599490659213-e2b9527bd087?auto=format&fit=crop&w=600&q=80"
        ),
        FoodItem(
            id: "7",
            name: "Special garlic\nsauce",
            price: "N500",
            category: "Sauce",
            imageUrl:
                "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=600&q=80"
        ),
    ]

    var filteredItems: [FoodItem] {
        foodItems.filter { item in
            let matchesCategory =
                item.category.lowercased() == selectedCategory.lowercased()
            if searchText.isEmpty {
                return matchesCategory
            } else {
                return item.name.localizedCaseInsensitiveContains(searchText)
                    || item.category.localizedCaseInsensitiveContains(
                        searchText
                    )
            }
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                topNavigationBar
                Spacer(minLength: 40)

                headerText

                searchBarField
                Spacer(minLength: 46)

                categoryTabs
                Spacer(minLength: 40)

                seeMoreButton

                foodCarouselSection
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(AppColors.background.ignoresSafeArea())
    }

    private var topNavigationBar: some View {
        HStack {
            Button {
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 22, height: 2.5)
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 15, height: 2.5)
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 18, height: 2.5)
                }
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "cart")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
        }
        .padding(.horizontal, 40)
    }

    private var headerText: some View {
        Text("Delicious\nfood for you")
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .foregroundStyle(Color.black)
            .lineSpacing(4)
            .padding(.horizontal, 40)
    }

    private var searchBarField: some View {
        HStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.7))

            TextField("Search", text: $searchText)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.black)
        }
        .padding(.horizontal, 35)
        .frame(height: 60)
        .background(Color("TextFieldColor"))
        .clipShape(Capsule())
        .padding(.horizontal, 40)
    }

    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 36) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = selectedCategory == category

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Text(category)
                                .font(
                                    .system(
                                        size: 17,
                                        weight: isSelected
                                            ? .semibold : .regular
                                    )
                                )
                                .foregroundStyle(
                                    isSelected ? AppColors.primary : Color.gray
                                )

                            Rectangle()
                                .fill(
                                    isSelected ? AppColors.primary : Color.clear
                                )
                                .frame(height: 3)
                                .cornerRadius(1.5)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 40)
        }
    }

    private var seeMoreButton: some View {
        HStack {
            Spacer()
            Button {
            } label: {
                Text("see more")
                    .font(.system(size: 15, weight: .medium))

                    .foregroundStyle(AppColors.primary)
                    .padding(.bottom, -10)
            }
        }
        .padding(.horizontal, 40)
    }

    private var foodCarouselSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 34) {
                ForEach(filteredItems) { item in
                    FoodCardView(
                        item: item,
                        onAdd: {
                            router.push(.foodDetail(item: item))
                        }
                    )
                }
            }
            .padding(.horizontal, 40)
            //            .padding(.top, 10)
            .padding(.bottom, 30)
        }
    }
}

struct FoodCardView: View {
    let item: FoodItem
    let onAdd: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                Spacer()
                    .frame(height: 145)

                Text(item.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.price)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .frame(width: 220, height: 270)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 10)
            .padding(.top, 55)

            AsyncImage(url: URL(string: item.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    foodPlaceholder
                @unknown default:
                    foodPlaceholder
                }
            }
            .frame(width: 164, height: 164)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 8)
        }
        .frame(width: 220, height: 350)
        .onTapGesture {
            onAdd()
        }
    }

    private var foodPlaceholder: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.orange.opacity(0.3), Color.red.opacity(0.2),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(AppColors.primary)
        }
    }
}

#Preview {
    AppNavigationStack {
        HomeView()
    }
}
