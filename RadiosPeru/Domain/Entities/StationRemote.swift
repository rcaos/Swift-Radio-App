//
//  StationRemote.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct StationRemote {
    
    let name: String
    let image: String
    let city: String
    let frecuency: String
    let slogan: String
    let urlStream: String
    
    let group: String
    let groupId: String
    let groupBase: String
}

// MARK: - TODO QUITAR de AQUí !!!

extension StationRemote: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case image
        case city
        case frecuency
        case slogan
        case urlStream
        case group
    }
    
    //MARK: - Initializer
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        self.city = try container.decode(String.self, forKey: .city)
        self.frecuency = try container.decode(String.self, forKey: .frecuency)
        self.slogan = try container.decode(String.self, forKey: .slogan)
        self.urlStream = try container.decode(String.self, forKey: .urlStream)
        
        let customGroup = try container.decode(Group.self, forKey: .group)
        switch customGroup {
        case .rpp(let rpp):
            self.group = rpp.type
            self.groupId = rpp.id
            self.groupBase = ""
        case .crp(let crp):
            self.group = crp.type
            self.groupId = ""
            self.groupBase = crp.base
        case .unknown:
            self.group = ""
            self.groupId = ""
            self.groupBase = ""
        }
    }
}

extension StationRemote {
    
    var type: Group {
        if group == "rpp" {
            return .rpp( RPP(type: self.group, id: self.groupId) )
            
        } else if group == "crp" {
            return .crp( CRP(type: self.group, base: self.groupBase) )
            
        } else {
            return .unknown
        }
    }
}
