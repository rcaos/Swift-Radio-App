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
        let results = Station.fetch(in: managedObjectContext, matching: predicate)
        
        //MARK: - FIX Return in order
        //Why order like that? and not using a Sort Descriptor?
        //Because its not exists relationships between tables @@
        var orderResults:[Station] = []
        for favorite in favorites {
            for result in results {
                if favorite.name == result.name {
                    orderResults.append(result)
                }
            }
        }
        
        return orderResults
    }
    
}
