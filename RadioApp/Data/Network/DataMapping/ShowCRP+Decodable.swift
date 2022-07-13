//
//  ShowCRP+Decodable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension ShowCRP: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "programa_id"
        case name = "programa"
        case imageURL = "img_200"
        case horario
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        
        self.horario = try container.decode(String.self, forKey: .horario)
    }
}
