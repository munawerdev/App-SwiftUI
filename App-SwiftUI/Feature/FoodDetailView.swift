import SwiftUI

struct FoodDetailView: View {
    @Environment(Router.self) private var router

    let item: FoodItem

    @State private var isFavorite: Bool = false
    @State private var currentPage: Int = 0

    private let sampleImagesCount = 4

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Navigation Bar
            topNavigationBar

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 28) {
                    // MARK: - Image Carousel Section
                    imageCarouselSection

                    // MARK: - Title and Price
                    titleAndPriceSection

                    // MARK: - Details Info Sections
                    detailsSection

                    // MARK: - Add to Cart Button
                    AppButton(
                        title: "Add to cart",
                        backgroundColor: AppColors.primary,
                        foregroundColor: .white,
                        horizontalPadding: 45
                    ) {
                        // Add to cart action
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.black)
                    .frame(width: 40, height: 40)
            }

            Spacer()

            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isFavorite ? AppColors.primary : Color.black)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }

    // MARK: - Image Carousel Section
    private var imageCarouselSection: some View {
        VStack(spacing: 24) {
            TabView(selection: $currentPage) {
                ForEach(0..<sampleImagesCount, id: \.self) { index in
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
                    .frame(width: 240, height: 240)
                    .clipShape(Circle())
                    .shadow(
                        color: Color.black.opacity(0.15),
                        radius: 20,
                        x: 0,
                        y: 12
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 260)

            // Page Indicator Dots
            HStack(spacing: 10) {
                ForEach(0..<sampleImagesCount, id: \.self) { index in
                    Circle()
                        .fill(
                            currentPage == index
                                ? AppColors.primary : Color.gray.opacity(0.3)
                        )
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    // MARK: - Title & Price Section
    private var titleAndPriceSection: some View {
        VStack(spacing: 10) {
            Text(item.name.replacingOccurrences(of: "\n", with: " "))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)

            Text(item.price)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(AppColors.primary)
        }
        .padding(.horizontal, 30)
    }

    // MARK: - Details Info Sections
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Delivery info")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.black)

                Text(
                    "Delivered between monday aug and thursday 20 from 8pm to 91:32 pm"
                )
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.55))
                .lineSpacing(4)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Return policy")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.black)

                Text(
                    "All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately."
                )
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.55))
                .lineSpacing(4)
            }
        }
        .padding(.horizontal, 45)
    }

    // MARK: - Placeholder View
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
                .frame(width: 120, height: 120)
                .foregroundStyle(AppColors.primary)
        }
    }
}

#Preview {
    AppNavigationStack {
        FoodDetailView(
            item: FoodItem(
                id: "1",
                name: "Veggie tomato mix",
                price: "N1,900",
                category: "Foods",
                imageUrl:
                    "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80"
            )
        )
    }
}
