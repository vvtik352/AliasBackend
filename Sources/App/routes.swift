import Vapor


func routes(_ app: Application) throws {
    
    app.post("register"){req  -> EventLoopFuture<User> in
            let data = try req.content.decode(User.self)
            let user = User(username: data.username, password: data.password)
        print("--sosi-->>>",req.db.schema("_fluent_migrations") )
        return  user.save(on: req.db).map{user}
    }
    
    app.get("getUsers"){req -> String in
        print(app.db)
        return "look in logs"
    }
}
