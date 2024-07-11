import SwiftUI

struct ProductsPage: View {
    let products: [Product]
    
    init(_ products: [Product]) {
        self.products = products
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 2),
                alignment: .leading
            ) {
                ForEach(products) { product in
                    NavigationLink {
                        ProductScreen(product)
                    } label: {
                        VStack(alignment: .leading) {
                            ProductImage(product.images.first!)
                                .aspectRatio(1, contentMode: .fit)
                            Text(product.name)
                                .lineLimit(2)
                            Text("$\(product.price)")
                                .foregroundStyle(.red)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
