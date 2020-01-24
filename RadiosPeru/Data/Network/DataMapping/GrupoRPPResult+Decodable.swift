//
//  GrupoRPPResult+Decodable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension GroupRPPResult: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.results = try container.decode(ShowWrapper.self, forKey: .results)
    }
}

extension ShowWrapper: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case radioDetail = "PI"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.radioDetail = try container.decode(ShowRPP.self, forKey: .radioDetail)
    }
}
