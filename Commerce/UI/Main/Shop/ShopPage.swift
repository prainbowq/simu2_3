import SwiftUI
import SwiftData

struct ShopPage: View {
    let products: [Product]
    @Environment(\.modelContext) private var modelContext
    @State private var productToDelete: Product?
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(products.filter { $0.seller == CommerceApp.user.name }) { product in
                    HStack {
                        ProductImage(product.images.first!)
                            .aspectRatio(1, contentMode: .fit)
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .lineLimit(2)
                            Text("$\(product.price)")
                                .foregroundStyle(.red)
                            Text("在架數量：\(product.amount)")
                            Spacer()
                            HStack {
                                Spacer()
                                NavigationLink {
                                    AddingScreen(products: products, product: product)
                                } label: {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: 40, height: 40)
                                Button(role: .destructive) {
                                    productToDelete = product
                                } label: {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: 40, height: 40)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(height: 150)
                }
            }
        }
        .alert("確認", isPresented: .constant(productToDelete != nil)) {
            Button("否") {
                productToDelete = nil
            }
            Button("是") {
                modelContext.delete(productToDelete!)
                productToDelete = nil
            }
        } message: {
            Text("確定要刪除此商品？")
        }
    }
}
