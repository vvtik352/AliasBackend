//
//  File.swift
//  
//
//  Created by 1234 on 26.03.2023.
//

import Vapor

import Fluent

final class Team: Content, Model {
    static var schema = "teams"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "roomId")
    var roomId: String
    
    @Field(key: "size")
    var size: uint8
    init() {}
    
    init(
         id: UUID? = nil,
         roomId: String,
         size: uint8
    ) {
        self.id = id
        self.roomId = roomId
        self.size = size
    }
}
