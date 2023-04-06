//
//  File.swift
//  
//
//  Created by Vladimir on 06.04.2023.
//

import Foundation
import Vapor

struct LoginRequest: Content {
    let username: String
    let password: String
}
