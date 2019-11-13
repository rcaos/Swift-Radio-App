//
//  StationFavorite.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

//No deben set Optionals
//todas las variables fileprivate
//hacer la final class
//Crear static func insert, para inserción manual

final class StationFavorite: NSManagedObject {
    
    @NSManaged fileprivate(set) var createAt: Date
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var group: String
    
    static func insert(into context: NSManagedObjectContext, name: String, group: String) -> StationFavorite{
        let favorite: StationFavorite = context.insertObject()
        
        favorite.name = name
        favorite.group = group
        favorite.createAt = Date()
        
        return favorite
    }
}

extension StationFavorite: Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(createAt), ascending: false) ]
    }
}
