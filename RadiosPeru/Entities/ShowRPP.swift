//
//  RadioShow.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct ShowRPP: Show, Codable {
    
    var id: String
    var name: String
    var imageURL: String
    
    var startTime: String
    var endTime: String
    
    enum CodingKeys: String, CodingKey {
        case id = "rpId"
        case name
        case imageURL = "imageWeb"
        
        case startTime
        case endTime = "stopTime"
    }
}

extension ShowRPP {
    var horario: String {
        return startTime + " - " + endTime
    }
}
