//
//  File.swift
//  
//
//  Created by 1234 on 06.04.2023.
//

import Foundation
import Vapor
import Fluent
import Crypto

struct TeamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let teamsRoute = routes.grouped("teams")
        let protected = teamsRoute.grouped(User.authenticator(), User.guardMiddleware())
        teamsRoute.post("createTeam", use: createHandler)
    }
    
    func createHandler(req:Request) throws -> EventLoopFuture<Team> {
        let teamReq = try req.content.decode(Team.self)
        
        let team = Team (
            id: UUID(),
            roomId: teamReq.roomId,
            size: teamReq.size
        )

        return teamReq.save(on: req.db).map { team }
    }
    
}
