import SwiftUI
import SwiftData

struct ProductImage: View {
    let name: String
    @Query private let productImageModels: [ProductImageModel]
    
    init(_ name: String) {
        self.name = name
    }
    
    var body: some View {
        if let data = productImageModels.first(where: { $0.name == name })?.data {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .scaledToFit()
        } else {
            Image(name)
                .resizable()
                .scaledToFit()
        }
    }
}
