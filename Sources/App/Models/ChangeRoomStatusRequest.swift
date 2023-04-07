//
//  File.swift
//  
//
//  Created by Vladimir on 07.04.2023.
//

import Foundation
import Vapor

struct ChangeRoomStatusRequest: Content {
    var status: RoomStatus
}
