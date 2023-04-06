//
//  RoomController.swift
//
//
//  Created by Vladimir on 06.04.2023.
//

import Foundation
import Vapor
import Fluent

struct RoomController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let roomsRoute = routes.grouped("rooms")
        
        let protected = roomsRoute.grouped(User.authenticator(), User.guardMiddleware())
        roomsRoute.post("createRoom", use: createHandler)
    }
    
    func createHandler(req:Request) throws -> EventLoopFuture<Room> {
        let roomReq = try req.content.decode(Room.self)
        
        let room = Room(
            roomName: roomReq.roomName,
            adminId: roomReq.adminId,
            numOfTeams: roomReq.numOfTeams,
            status: roomReq.status
        )
        return roomReq.save(on: req.db).map { room }
    }
    
}
