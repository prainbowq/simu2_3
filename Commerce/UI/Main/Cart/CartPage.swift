import SwiftUI

struct CartPage: View {
    let products: [Product]
    @State private var itemToDelete: Product?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(CommerceApp.user.cart) { item in
                    let product = products.first { $0.id == item.id }!
                    HStack {
                        ProductImage(item.images.first!)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .lineLimit(2)
                            Text("$\(item.price)")
                                .foregroundStyle(.red)
                            Text("在架數量：\(product.amount)")
                            Spacer()
                            HStack {
                                Stepper(
                                    "訂購數量：\(item.amount)",
                                    value: Binding { item.amount } set: { item.amount = $0 },
                                    in: 1...product.amount
                                )
                                Button(role: .destructive) {
                                    itemToDelete = item
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
            }
        }
        .alert("確認", isPresented: .constant(itemToDelete != nil)) {
            Button("否") {
                itemToDelete = nil
            }
            Button("是") {
                CommerceApp.user.cart.remove(at: CommerceApp.user.cart.firstIndex(of: itemToDelete!)!)
                itemToDelete = nil
            }
        } message: {
            Text("確定要刪除此產品？")
        }
    }
}
