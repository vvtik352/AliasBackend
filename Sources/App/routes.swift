import Vapor

struct UserAuthenticator: BasicAuthenticator {
    typealias User = App.User

    func authenticate(
        basic: BasicAuthorization,
        for request: Request
    ) -> EventLoopFuture<Void> {
        if basic.username == "test" && basic.password == "secret" {
            request.auth.login(User(name: "TestUser"))
        }
        return request.eventLoop.makeSucceededFuture(())
   }
}


func routes(_ app: Application) throws {
    
    let protected =  app.grouped(UserAuthenticator())
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("auth") { req in
        "{d}"
//        return req
    }
}
