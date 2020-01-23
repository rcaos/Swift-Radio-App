//
//  ShowRPP+Decodable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension ShowRPP: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "rpId"
        case name
        case imageURL = "imageWeb"
        
        case startTime
        case endTime = "stopTime"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
    }
}
