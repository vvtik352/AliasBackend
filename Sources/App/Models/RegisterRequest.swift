//
//  File.swift
//  
//
//  Created by Vladimir on 27.03.2023.
//

import Vapor

struct RegisterRequest: Content {
    let username: String
    let password: String
}
