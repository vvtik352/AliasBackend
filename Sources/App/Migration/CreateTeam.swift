//
//  File.swift
//
//
//  Created by 1234 on 27.03.2023.
//
import Fluent

struct CreateTeam: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("teams")
            .id()
            .field("roomId", .string, .required)
            .field("size", .uint8, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("teams").delete()
    }
    
}
