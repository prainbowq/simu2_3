import SwiftData

@Model
final class User {
    var id: Int
    var role: String
    var name: String
    var email: String
    var password: String
    var cart: [Product]
    
    init(id: Int, role: String, name: String, email: String, password: String, cart: [Product]) {
        self.id = id
        self.role = role
        self.name = name
        self.email = email
        self.password = password
        self.cart = cart
    }
    
    struct Json: Decodable {
        var id: Int
        var role: String
        var name: String
        var email: String
        var password: String
    }
    
    static func fromJson(_ json: Json) -> User {
        User(
            id: json.id,
            role: json.role,
            name: json.name,
            email: json.email,
            password: json.password,
            cart: []
        )
    }
}
