//
//  PersistenceStore+Station.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

extension PersistenceStore where Entity == Station {
    
    func findAll() -> [Station] {
        return Station.fetch(in: managedObjectContext)
    }
    
    func findFavorites() -> [Station] {
        
        let favorites = StationFavorite.fetch(in: managedObjectContext)
        let names = favorites.map({ $0.name })
        
        let predicate = NSPredicate(format: "ANY name in %@ ", names)
        return Station.fetch(in: managedObjectContext, matching: predicate)
    }
    
}
