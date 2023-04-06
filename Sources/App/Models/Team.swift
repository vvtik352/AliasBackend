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
    var roomId: UUID
    
    @Field(key: "size")
    var size: Int
}
