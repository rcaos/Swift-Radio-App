//
//  GrupoRPPResponse.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct GrupoRPPResult: Decodable{
    let results: ShowWrapper
}

struct ShowWrapper: Codable{
    let radioDetail: ShowRPP
    
    enum CodingKeys: String, CodingKey {
        case radioDetail = "PI"
    }
}
