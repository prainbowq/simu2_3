import SwiftUI
import SwiftData

struct MainScreen: View {
    @Query private let products: [Product]
    @State private var tabName = ""
    @State private var processedProducts = [Product]()
    
    var body: some View {
        let tabs = [
            "買家": [
                (AnyView(ProductsPage(processedProducts)), "產品列表", "list.bullet"),
                (AnyView(CartPage(products: products)), "購物車", "cart")
            ],
            "賣家": [
                (AnyView(ShopPage(products: products)), "我的賣場", "house"),
                (AnyView(Text("6")), "販售情況", "chart.xyaxis.line")
            ]
        ][CommerceApp.user.role]! + [
            (AnyView(RecordsPage()), "我的訂單", "doc.plaintext"),
            (AnyView(UserPage()), "個人資料", "person")
        ]
        TabView(selection: $tabName) {
            ForEach(tabs, id: \.1) { tab in
                if tab.1 == "購物車" {
                    tab.0
                        .tabItem {
                            Label(tab.1, systemImage: tab.2)
                        }
                        .badge(CommerceApp.user.cart.count)
                } else {
                    tab.0
                        .tabItem {
                            Label(tab.1, systemImage: tab.2)
                        }
                }
            }
        }
        .navigationTitle(tabName)
        .toolbar {
            if tabName == "我的賣場" {
                ToolbarItem {
                    NavigationLink {
                        AddingScreen(products: products)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            tabName = tabs.first!.1
        }
        .task {
            processedProducts = products.filter { $0.available }.shuffled()
        }
    }
}
