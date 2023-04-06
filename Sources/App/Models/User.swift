import Vapor
import Fluent

final class User: Model, Content, ResponseEncodable {
    func encodeResponse(for request: Vapor.Request) -> NIOCore.EventLoopFuture<Vapor.Response> {
        do {
            let response = Response(status: .ok)
            try response.content.encode(self, using: request.content as! ContentEncoder)
                  return request.eventLoop.future(response)
              } catch {
                  return request.eventLoop.makeFailedFuture(error)
              }
        
    }
    
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
}
