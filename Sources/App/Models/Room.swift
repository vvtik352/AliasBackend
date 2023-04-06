//
//  File.swift
//  
//
//  Created by 1234 on 26.03.2023.
//

import Vapor
import Fluent

final class Room: Content, Model {
    static var schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "adminId")
    var adminId: UUID
    
    @Field(key: "teams")
    var numOfTeams: Int
    
    @Field(key: "status")
    var status: RoomStatus
}
