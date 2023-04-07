//
//  File.swift
//  
//
//  Created by Vladimir on 06.04.2023.
//

import Foundation
import Vapor

struct CreateRoomRequest: Content {
    var roomName: String
    var adminId: UUID
    var numOfTeams: Int
    var status: RoomStatus
}
