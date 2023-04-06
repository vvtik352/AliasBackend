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
    }

    func register(req: Request) throws -> EventLoopFuture<User> {
        let registerRequest = try req.content.decode(RegisterRequest.self)

        guard registerRequest.password.count >= 8 else {
            throw Abort(.badRequest, reason: "Password must be at least 8 characters long")
        }

        let user = User(username: registerRequest.username, password: registerRequest.password)
        
        return user.save(on: req.db).map { user }
    }
    
//    func login(req: Request) throws -> EventLoopFuture<String> {
//           let loginRequest = try req.content.decode(RegisterRequest.self)
//
//           return User.query(on: req.db)
//               .filter(\.$username == loginRequest.username)
//               .first()
//               .unwrap(or: Abort(.notFound, reason: "User not found"))
//               .flatMap { user in
//                   let passwordMatch = try Bcrypt.verify(loginRequest.password, created: user.password)
//                   guard passwordMatch else {
//                       return req.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "Incorrect password"))
//                   }
//
//                   return req.eventLoop.makeSucceededFuture("Login successful")
//               }
//       }
    
    
}
