import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    init() {}
    
    init(
        id: UUID? = nil,
        username: String,
        password: String,
        isAdmin: Bool = false
    ) {
        self.id = id
        self.username = username
        self.password = password
    }
    
    final class Public: Content {
        var id: UUID?
        var username: String
        
        init(id:UUID? = nil, username:String){
            self.id = id
            self.username = username
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        User.Public(id:self.id, username: self.username)
    }
}

extension User: ModelAuthenticatable  {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        print("zopa",self.password);
        
        return try Bcrypt.verify(password, created: self.password)
    }
}
