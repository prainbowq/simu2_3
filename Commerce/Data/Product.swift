import SwiftData

@Model
final class Product {
    var id: Int
    var seller: String
    var name: String
    var typeId: Int
    var type: String
    var subType: String
    var item: String
    var images: [String]
    var description_: String
    var price: Int
    var amount: Int
    var fare: Int
    var available: Bool
    
    init(id: Int, seller: String, name: String, typeId: Int, type: String, subType: String, item: String, images: [String], description_: String, price: Int, amount: Int, fare: Int, available: Bool) {
        self.id = id
        self.seller = seller
        self.name = name
        self.typeId = typeId
        self.type = type
        self.subType = subType
        self.item = item
        self.images = images
        self.description_ = description_
        self.price = price
        self.amount = amount
        self.fare = fare
        self.available = available
    }
    
    func copy() -> Product {
        Product(
            id: id,
            seller: seller,
            name: name,
            typeId: typeId,
            type: type,
            subType: subType,
            item: item,
            images: images,
            description_: description_,
            price: price,
            amount: amount,
            fare: fare,
            available: available
        )
    }
    
    struct Json: Decodable {
        var id: Int
        var seller: String
        var name: String
        var typeId: Int
        var type: String
        var subType: String
        var item: String
        var picture: String
        var description: String
        var price: Int
        var amount: Int
        var fare: Int
        var available: Bool
    }
    
    static func fromJson(_ json: Json) -> Product {
        Product(
            id: json.id,
            seller: json.seller,
            name: json.name,
            typeId: json.typeId,
            type: json.type,
            subType: json.subType,
            item: json.item,
            images: json.picture
                .split(separator: ",")
                .map { String($0.split(separator: ".").first!) },
            description_: json.description,
            price: json.price,
            amount: json.amount,
            fare: json.fare,
            available: json.available
        )
    }
}
