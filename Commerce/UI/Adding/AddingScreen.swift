import SwiftUI
import SwiftData
import PhotosUI

struct AddingScreen: View {
    let products: [Product]
    let product: Product?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private let productImageModels: [ProductImageModel]
    @State private var photosPickerItems = [PhotosPickerItem]()
    @State private var images = [String]()
    @State private var name = ""
    @State private var priceString = ""
    @State private var type = CommerceApp.productTypes.first!.type
    @State private var subType = CommerceApp.productTypes.first!.subType
    @State private var item = CommerceApp.productTypes.first!.item
    @State private var amount = 1
    @State private var description = ""
    @State private var failure: String?
    @State private var success: String?
    
    init(products: [Product], product: Product? = nil) {
        self.products = products
        self.product = product
    }
    
    func add() {
        guard !images.isEmpty else {
            failure = "至少需要一張圖片。"
            return
        }
        guard !name.isEmpty else {
            failure = "名稱不可為空。"
            return
        }
        guard let price = Int(priceString), price > 0 else {
            failure = "價格無效。"
            return
        }
        guard !description.isEmpty else {
            failure = "說明不可為空。"
            return
        }
        let typeId = CommerceApp.productTypes.first {
            $0.type == type && $0.subType == subType && $0.item == item
        }!.id
        if let product {
            product.images = images
            product.name = name
            product.price = price
            product.typeId = typeId
            product.type = type
            product.subType = subType
            product.item = item
            product.amount = amount
            product.description_ = description
            success = "修改成功！"
        } else {
            modelContext.insert(
                Product(
                    id: (products.map { $0.id }.max() ?? 0) + 1,
                    seller: CommerceApp.user.name,
                    name: name,
                    typeId: typeId,
                    type: type,
                    subType: subType,
                    item: item,
                    images: images,
                    description_: description,
                    price: price,
                    amount: amount,
                    fare: 0,
                    available: true
                )
            )
            success = "新增成功！"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                PhotosPicker(selection: $photosPickerItems) {
                    TabView {
                        if images.isEmpty {
                            Image(systemName: "arrow.up.doc")
                        } else {
                            ForEach(images, id: \.self) {
                                ProductImage($0)
                            }
                        }
                    }
                    .task(id: photosPickerItems) {
                        if product != nil && photosPickerItems.isEmpty {
                            return
                        }
                        images = []
                        photosPickerItems.forEach {
                            let name = "\(UUID())"
                            $0.loadTransferable(type: Data.self) {
                                modelContext.insert(
                                    ProductImageModel(
                                        name: name,
                                        data: try! $0.get()!
                                    )
                                )
                            }
                            images.append(name)
                        }
                    }
                    .tabViewStyle(.page)
                    .aspectRatio(1, contentMode: .fit)
                }
                TextField("名稱", text: $name)
                    .font(.headline)
                HStack {
                    Text("$")
                    TextField("價格", text: $priceString)
                }
                .foregroundStyle(.red)
                Divider()
                Grid(alignment: .leading) {
                    GridRow {
                        Text("類組")
                            .font(.headline)
                        Picker(selection: $type) {
                            ForEach(
                                CommerceApp.productTypes
                                    .map { $0.type }
                                    .distinct(),
                                id: \.self
                            ) {
                                Text($0)
                            }
                        } label: {}
                            .onChange(of: type) {
                                subType = CommerceApp.productTypes.first { $0.type == type }!.subType
                            }
                    }
                    GridRow {
                        Text("主類")
                            .font(.headline)
                        Picker(selection: $subType) {
                            ForEach(
                                CommerceApp.productTypes
                                    .filter { $0.type == type }
                                    .map { $0.subType }
                                    .distinct(),
                                id: \.self
                            ) {
                                Text($0)
                            }
                        } label: {}
                            .onChange(of: subType) {
                                item = CommerceApp.productTypes.first {
                                    $0.type == type && $0.subType == subType
                                }!.item
                            }
                    }
                    GridRow {
                        Text("副類")
                            .font(.headline)
                        Picker(selection: $item) {
                            ForEach(
                                CommerceApp.productTypes
                                    .filter { $0.type == type && $0.subType == subType }
                                    .map { $0.item },
                                id: \.self
                            ) {
                                Text($0)
                            }
                        } label: {}
                    }
                    GridRow {
                        Text("在架數量")
                            .font(.headline)
                        Stepper("\(amount)", value: $amount, in: 1...Int.max)
                    }
                }
                TextEditor(text: $description)
                    .frame(minHeight: 300)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("完成", action: add)
            }
        }
        .alert("失敗", isPresented: .constant(failure != nil)) {
            Button("確認") {
                failure = nil
            }
        } message: {
            Text(failure ?? "")
        }
        .alert("成功", isPresented: .constant(success != nil)) {
            Button("確認") {
                dismiss()
            }
        } message: {
            Text(success ?? "")
        }
        .onAppear {
            if let product {
                images = product.images
                name = product.name
                priceString = String(product.price)
                type = product.type
                subType = product.subType
                item = product.item
                amount = product.amount
                description = product.description_
            }
        }
    }
}
