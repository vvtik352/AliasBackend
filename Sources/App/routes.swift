import Vapor


func routes(_ app: Application) throws {
  
    try app.register(collection: UserController())
    try app.register(collection: RoomController())
    
//    app.post("register",use:UserController().register)
//    app.post("login",use: UserController().login)
//
//
//    let protectedRooms = app.grouped(User.authenticator())
//    protectedRooms.post("createRoom", use:RoomController().createHandler)
//

    app.get("getUsers"){req -> EventLoopFuture<[User]> in
        return User.query(on: req.db).all()
    }
}
