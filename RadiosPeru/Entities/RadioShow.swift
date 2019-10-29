//
//  RadioShow.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct RadioShow: Codable{
    
    let radioName: String
    let name: String
    let description: String
    let imageURL: String
    let startTime: String
    let endTime: String
    
    enum CodingKeys: String, CodingKey {
        case radioName = "serviceName"
        case name
        case description
        case imageURL = "imageWeb"
        case startTime
        case endTime = "stopTime"
    }
}
