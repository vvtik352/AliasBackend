//
//  File.swift
//  
//
//  Created by Vladimir on 27.03.2023.
//

import Foundation
import Vapor
import Fluent
import Crypto

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("users")
        usersRoute.post("register", use: register)
//        usersRoute.post("")
//        let passwordProtected = routes.grouped(User.authenticator())
//        passwordProtected.post("login") { req -> User in
//            try req.auth.require(User.self)
//        }
    }

    func register(req: Request) throws -> EventLoopFuture<User.Public> {
        let registerRequest = try req.content.decode(RegisterRequest.self)

        guard registerRequest.password.count >= 4 else {
            throw Abort(.badRequest, reason: "Password must be at least 8 characters long")
        }
        
        let user = User(
            username: registerRequest.username,
            password: try Bcrypt.hash(registerRequest.password)
        )
        
        return user.save(on: req.db).map { user.convertToPublic() }
    }
//    func delete(_ req:Request) throws-> Response {
//        let user =  User.find(req.parameters.get("username"), on: req.db)
////        try user.delete(on:req.db)
//        return Response.
//    }
    
    func login(req: Request) throws -> EventLoopFuture<String>  {
        let loginRequest = try req.content.decode(LoginRequest.self)
                  
        return User.query(on: req.db)
            .filter(\.$username == loginRequest.username)
            .first()
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .flatMap { user -> EventLoopFuture<String> in
                do {
                    let passwordMatch = try Bcrypt.verify(loginRequest.password, created: user.password)

                    if passwordMatch {
                        return req.eventLoop.makeSucceededFuture("Login successful")
                    } else {
                        return req.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "Incorrect password"))
                    }
                } catch{
                    return req.eventLoop.makeFailedFuture(Abort(.conflict, reason: "hz"))
                }
            }
       }
    
    
}
