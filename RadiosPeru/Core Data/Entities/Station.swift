//
//  Station.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class Station: NSManagedObject {
    
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var image: String
    @NSManaged fileprivate(set) var city: String
    @NSManaged fileprivate(set) var frecuency: String
    @NSManaged fileprivate(set) var slogan: String
    @NSManaged fileprivate(set) var urlStream: String
    
    @NSManaged fileprivate(set) var group: String
    @NSManaged fileprivate(set) var groupId: String
    @NSManaged fileprivate(set) var groupBase: String
    
}

extension Station: Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: false) ]
    }
}


//MARK: - Decodable

extension Station: Decodable {
    
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
    
    convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Missing context or invalid context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: Station.entityName, in: context) else {
            fatalError("Unknown entity in context")
        }
        
        self.init(entity: entity, insertInto: context)
        
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

extension Station {
    
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
