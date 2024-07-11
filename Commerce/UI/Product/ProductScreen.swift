import SwiftUI

struct ProductScreen: View {
    let product: Product
    @State private var amount = 1
    @State private var success = false
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TabView {
                    ForEach(product.images, id: \.self) {
                        ProductImage($0)
                    }
                }
                .tabViewStyle(.page)
                .aspectRatio(1, contentMode: .fit)
                Text(product.name)
                    .font(.headline)
                Text("$\(product.price)")
                    .foregroundStyle(.red)
                Divider()
                Grid(alignment: .leading) {
                    GridRow {
                        Text("類組")
                            .font(.headline)
                        Text(product.type)
                    }
                    GridRow {
                        Text("主類")
                            .font(.headline)
                        Text(product.subType)
                    }
                    GridRow {
                        Text("副類")
                            .font(.headline)
                        Text(product.item)
                    }
                    GridRow {
                        Text("在架數量")
                            .font(.headline)
                        Text("\(product.amount)")
                    }
                }
                if product.description_.hasSuffix(".jpg") {
                    ProductImage(String(product.description_.split(separator: ".").first!))
                } else {
                    Text(product.description_)
                }
            }
        }
        .navigationTitle("產品明細")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                if CommerceApp.user.cart.contains(where: { $0.id == product.id }) {
                    Text("已在購物車中")
                } else {
                    HStack {
                        Stepper("訂購數量：\(amount)", value: $amount, in: 1...product.amount)
                        Button("加入購物車") {
                            let productCopy = product.copy()
                            productCopy.amount = amount
                            CommerceApp.user.cart.append(productCopy)
                            success = true
                        }
                    }
                }
            }
        }
        .alert("成功", isPresented: $success) {
            Button("確認") {}
        } message: {
            Text("已加入購物車！")
        }
    }
}
