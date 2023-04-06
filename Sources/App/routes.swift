import Vapor


func routes(_ app: Application) throws {
  
    app.post("register",use:UserController().register)
    app.post("login",use: UserController().login)
    
    app.post("createRoom", use:RoomController().createHandler)
    app.post("createTeam", use:TeamController().createHandler)
    

    app.get("getUsers"){req -> EventLoopFuture<[User]> in
        return User.query(on: req.db).all()
    }
}
