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
    func boot(routes: RoutesBuilder)  throws {
        let roomsRoute = routes.grouped("rooms")
        
        let authMiddleware = User.authenticator()
        let guardMiddleware = User.guardMiddleware()
        let protected = roomsRoute.grouped(authMiddleware, guardMiddleware)
        protected.post("create", use: createHandler)
        protected.post("addUser", use: addUserToRoom)
        protected.post("removeUser", use: removeUserFromRoom)
        protected.patch("changeStatus", use:  changeRoomStatus)
        protected.get("openRooms", use: getOpenRoomsHandler)
        protected.delete("delete", use:deleteRoom)
    }
    
    func createHandler(req: Request) throws -> EventLoopFuture<Room> {
        let createRoomRequest = try req.content.decode(CreateRoomRequest.self)
        guard createRoomRequest.numOfTeams >= 2 else {
            throw Abort(.badRequest, reason: "Min teams count is 2")
        }
           let room = Room(
               roomName: createRoomRequest.roomName,
               adminId: createRoomRequest.adminId,
               numOfTeams: createRoomRequest.numOfTeams,
               status: createRoomRequest.status
           )
      
        return room.save(on: req.db).map { room }

    }
    
    func getOpenRoomsHandler(req: Request) throws -> EventLoopFuture<[Room]> {
        let rooms =  try Room.query(on: req.db)
//            .filter(\.$status == RoomStatus.OPEN)
            .all()
        return rooms
    }
    
    func addUserToRoom(req: Request) throws -> EventLoopFuture<Room> {
        let roomId = try req.query.get(UUID.self, at: "roomId")
        let userId = try req.query.get(UUID.self, at: "userId")
        
        return Room.find(roomId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { room in
                if !room.userIds.contains(userId) {
                    room.userIds.append(userId)
                    return room.save(on: req.db).map { room }
                } else {
                    return req.eventLoop.future(room)
                }
            }
    }
    
    func changeRoomStatus(req: Request)  throws -> EventLoopFuture<Room>  {
        let roomId = try req.query.get(UUID.self, at: "roomId")
        let userId = try req.query.get(UUID.self, at: "userId")
        
        let updateStatusRequest = try req.content.decode(ChangeRoomStatusRequest.self)
        
        return Room.find(roomId, on: req.db)
               .unwrap(or: Abort(.notFound))
               .flatMap { room in
                   if(room.adminId == userId)
                   {
                       room.status = updateStatusRequest.status
                   }
                   else{
                       Abort(.locked, reason: "Вы не админ групры")
                   }
                   return room.save(on: req.db).map { room }
               }
//        let roomId = try req.query.get(UUID.self, at: "roomId")
//         let adminId = try req.query.get(String.self, at: "adminId")
//
//        print("sossi", roomId,adminId)
//
//        guard let room = try await Room.find(roomId, on: req.db) else {
//                throw Abort(.notFound)
//        }
////            if(userId == room.adminId){
//                let updateRoom = try req.content.decode(Room.self)
//
//                room.roomName = updateRoom.roomName
//                room.adminId = updateRoom.adminId
//                room.numOfTeams = updateRoom.numOfTeams
//                room.status = updateRoom.status
//
//                try await updateRoom.save(on: req.db)
//                return updateRoom
//
////            } else{
////                throw Abort(.locked,  reason: "Вы не админ этой комнаты")
////            }
        }
    
    func removeUserFromRoom(req: Request) throws -> EventLoopFuture<Room> {
        let roomId = try req.query.get(UUID.self, at: "roomId")
        let userId = try req.query.get(UUID.self, at: "userId")
        
        return Room.find(roomId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { room in
                room.userIds.removeAll { $0 == userId }
                return room.save(on: req.db).map { room }
            }
    }

    
    func deleteRoom(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let adminId = try req.query.get(UUID.self, at: "adminId")
        
        return Room.query(on: req.db)
            .filter(\.$adminId == adminId)
            .delete()
            .transform(to: .ok)
    }
}
