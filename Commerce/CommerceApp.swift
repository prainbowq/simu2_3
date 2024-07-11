import SwiftUI
import SwiftData

@main
struct CommerceApp: App {
    private static let decoder = JSONDecoder()
    static var user: User!
    static let productTypes: [ProductType] = try! decoder.decode(
        [ProductType].self,
        from: NSDataAsset(name: "Types")!.data
    )
    private let modelContainer = try! ModelContainer(for: User.self, Product.self, Record.self, ProductImageModel.self)
    
    init() {
        let context = modelContainer.mainContext
        if try! context.fetch(FetchDescriptor<User>()).isEmpty {
            try! CommerceApp.decoder.decode(
                [User.Json].self,
                from: NSDataAsset(name: "Users")!.data
            ).forEach { context.insert(User.fromJson($0)) }
        }
        if try! context.fetch(FetchDescriptor<Product>()).isEmpty {
            try! CommerceApp.decoder.decode(
                [Product.Json].self,
                from: NSDataAsset(name: "Products")!.data
            ).forEach { context.insert(Product.fromJson($0)) }
        }
        if try! context.fetch(FetchDescriptor<Record>()).isEmpty {
            try! CommerceApp.decoder.decode(
                [Record.Json].self,
                from: NSDataAsset(name: "Records")!.data
            ).forEach { context.insert(Record.fromJson($0)) }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginScreen()
            }
            .modelContainer(modelContainer)
        }
    }
}
