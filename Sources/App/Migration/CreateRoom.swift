//
//  File.swift
//  
//
//  Created by Vladimir on 06.04.2023.
//

import Fluent

struct CreateRoom: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("rooms")
            .id()
            .field("roomName", .string, .required)
            .field("adminId", .string, .required)
            .field("numOfTeams", .uint8, .required)
            .field("status", .string, .required)
            .field("userIds", .array)
            .unique(on: "roomName")
            .create()
    }
        
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("rooms").delete()
    }
}
