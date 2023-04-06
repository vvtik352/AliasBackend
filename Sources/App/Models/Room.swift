//
//  File.swift
//  
//
//  Created by 1234 on 26.03.2023.
//

import Vapor
import Fluent

final class Room: Model, Content {
    static var schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "roomName")
    var roomName: String
    
    @Field(key: "adminId")
    var adminId: String
    
    @Field(key: "numOfTeams")
    var numOfTeams: Int
    
    @Field(key: "status")
    var status: RoomStatus
    
    @Field(key: "users")
    var usersIds: [UUID]
    
    init() {}
    
    init(
         id: UUID? = nil,
         roomName: String,
         adminId: String,
         numOfTeams: Int,
         status: RoomStatus,
         usersIds: [UUID]
    ) {
        self.id = id
        self.roomName = roomName
        self.adminId = adminId
        self.numOfTeams = numOfTeams
        self.status = status
    }
}
