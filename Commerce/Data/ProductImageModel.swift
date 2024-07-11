import SwiftData
import Foundation

@Model
final class ProductImageModel {
    var name: String
    var data: Data
    
    init(name: String, data: Data) {
        self.name = name
        self.data = data
    }
}
