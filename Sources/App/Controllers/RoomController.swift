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
        
        let authMiddleware = User.authenticator()
        let guardMiddleware = User.guardMiddleware()
        let protected = roomsRoute.grouped(authMiddleware, guardMiddleware)
        protected.post("create", use: createHandler)
        protected.get("openRooms", use: getOpenRoomsHandler)
        protected.get("delete", use:deleteRoom)
    }
    
    func createHandler(req: Request) throws -> EventLoopFuture<Room> {
        let roomReq = try req.content.decode(Room.self)

        let room = Room(
            id: UUID(),
            roomName: roomReq.roomName,
            adminId: roomReq.adminId,
            numOfTeams: roomReq.numOfTeams,
            status: roomReq.status
        )
        
        return room.save(on: req.db).map { room }
        
    }
    
    func getOpenRoomsHandler(req: Request) throws -> EventLoopFuture<[Room]> {
        let rooms =  try Room.query(on: req.db)
            .filter(\.$status == RoomStatus.OPEN)
            .all()
        return rooms
    }
    
    func deleteRoom(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let adminId = try req.query.get(String.self, at: "adminId")
        
        return Room.query(on: req.db)
            .filter(\.$adminId == adminId)
            .delete()
            .transform(to: .ok)
    }
//    func deleteHandler(req: Request) throws -> Response{
//        let roomReq = try req.content.decode(Room.self)
//
//        Room.find(req.parameters.get("adminId"), on: req.db)
//        .unwrap(or: Abort(.notFound))
//        .flatMap { room in
//            room.delete(on: req.db)
//          }
//        return .ok
//
//    }
    
}
