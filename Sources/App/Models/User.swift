////
////  File.swift
////
////
////  Created by Vladimir on 25.03.2023.
////
//
//import Foundation
import Vapor
//import Fluent
//
//final class User: Authenticatable, Model, Content {
//    static let schema = "users"
//
//    @ID(key: .id)
//    var id: UUID?
//
//    @Field(key: "username")
//    var username: String
//
//    @Field(key: "password")
//    var password: String
//
//    init() {}
//
//    init(id: UUID? = nil, username: String, password: String) {
//        self.id = id
//        self.username = username
//        self.password = password
//    }
//}

struct User: Authenticatable {
    var name: String
}
