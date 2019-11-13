//
//  Group.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum Group {
    case rpp(RPP)
    case crp(CRP)
    case unknown
}

struct RPP: Decodable {
    let type: String
    let id: String
}

struct CRP: Decodable {
    let type: String
    let base: String
    
    private enum CodingKeys: String, CodingKey {
        case type
        case base = "base_url"
    }
}

//MARK: - Codable

extension Group: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeKey = try container.decode(String.self, forKey: .type)
        
        let typeValue = try decoder.singleValueContainer()
        
        switch typeKey {
        case "rpp":
            self = .rpp( try typeValue.decode(RPP.self) )
        case "crp":
            self = .crp( try typeValue.decode(CRP.self) )
        default:
            self = .unknown
        }
    }
}
