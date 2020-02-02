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
    
    @NSManaged var name: String
    @NSManaged var image: String
    @NSManaged var city: String
    @NSManaged var frecuency: String
    @NSManaged var slogan: String
    @NSManaged var urlStream: String
    
    @NSManaged var group: String
    @NSManaged var groupId: String
    @NSManaged var groupBase: String
}

extension Station {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
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
