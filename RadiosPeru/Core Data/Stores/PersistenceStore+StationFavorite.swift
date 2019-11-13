//
//  PersistenceStore+StationFavorite.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

extension PersistenceStore where Entity == StationFavorite {
    
    //MARK: - TODO, recibir notificaciones de add, remove
    
    func toggleFavorite(with name: String, group: String) -> Bool {
        if let favorite = findFavorite(with: name, group: group) {
            removeFavorite(favorite: favorite)
            return false
        } else {
            print("Se agrega a Favorite")
            saveStationFavorite(with: name, group: group)
            return true
        }
    }
    
    func isFavorite(with name: String, group: String) -> Bool {
        if let _ = findFavorite(with: name, group: group) {
            return true
        }
        return false
    }
    
    //MARK : - Private
    
    private func findFavorite(with name: String, group: String) -> StationFavorite?{
        let predicate = NSPredicate(format: "name == %@", name)
        return StationFavorite.findOrFetch(in: managedObjectContext, matching: predicate)
    }
    
    private func removeFavorite(favorite: StationFavorite) {
        managedObjectContext.performChanges {
            self.managedObjectContext.delete( favorite )
        }
        
        print("Se Elimino Objeto [\(favorite.name)]")
    }
    
    private func saveStationFavorite(with name: String, group: String) {
        managedObjectContext.performChanges {
            _ = StationFavorite.insert(into: self.managedObjectContext,
                                       name: name,
                                       group: group)
        }
    }
}
