import Foundation

struct FoodItem: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let price: String
    let category: String
    let imageUrl: String
}

struct Product: Identifiable, Hashable, Decodable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?  // some products (e.g. groceries) have no brand
    let sku: String
    let weight: Double
    let dimensions: Dimensions
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [Review]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: Meta
    let images: [String]
    let thumbnail: String

    struct Dimensions: Hashable, Decodable {
        let width: Double
        let height: Double
        let depth: Double
    }

    struct Review: Hashable, Decodable {
        let rating: Int
        let comment: String
        let date: String  // ISO-8601 string; parse to Date later if you need it
        let reviewerName: String
        let reviewerEmail: String
    }

    struct Meta: Hashable, Decodable {
        let createdAt: String
        let updatedAt: String
        let barcode: String
        let qrCode: String
    }
}

struct HomeModel: Decodable, Equatable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int

    // Lets HomeModel() work like HomeModel.fromJson({}) did in Dart
    init(
        products: [Product] = [],
        total: Int = 0,
        skip: Int = 0,
        limit: Int = 0
    ) {
        self.products = products
        self.total = total
        self.skip = skip
        self.limit = limit
    }

    // Missing keys fall back to defaults, like `json['x'] ?? ...`
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        products =
            try c.decodeIfPresent([Product].self, forKey: .products) ?? []
        total = try c.decodeIfPresent(Int.self, forKey: .total) ?? 0
        skip = try c.decodeIfPresent(Int.self, forKey: .skip) ?? 0
        limit = try c.decodeIfPresent(Int.self, forKey: .limit) ?? 0
    }

    private enum CodingKeys: String, CodingKey {
        case products, total, skip, limit
    }
}
