//
//  ShowCRP.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct ShowCRP: Show, Codable {
    
    let id: String
    let name: String
    let imageURL: String
    
    let horario: String
    
    enum CodingKeys: String, CodingKey {
        case id = "programa_id"
        case name = "programa"
        case imageURL = "img_200"
        case horario
    }
}
