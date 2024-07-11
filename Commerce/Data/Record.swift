import SwiftData

@Model
final class Record {
    var id: Int
    var buyer: String
    var status: String
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
    
    init(id: Int, buyer: String, status: String, seller: String, name: String, typeId: Int, type: String, subType: String, item: String, images: [String], description_: String, price: Int, amount: Int, fare: Int) {
        self.id = id
        self.buyer = buyer
        self.status = status
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
    }
    
    struct Json: Decodable {
        var id: Int
        var buyer: String
        var status: String
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
    }
    
    static func fromJson(_ json: Json) -> Record {
        Record(
            id: json.id,
            buyer: json.buyer,
            status: json.status,
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
            fare: json.fare
        )
    }
}
