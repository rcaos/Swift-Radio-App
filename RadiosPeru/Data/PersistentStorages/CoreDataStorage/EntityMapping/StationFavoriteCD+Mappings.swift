//
//  StationFavoriteCD+Mappings.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

extension StationFavoriteCD {
    
    convenience init(stationFavorite: SimpleStation, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.createAt = Date()
        self.name = stationFavorite.name
        self.group = stationFavorite.group
    }
}

extension SimpleStation {
    
    init(stationLocal: StationFavoriteCD) {
        name = stationLocal.name
        group = stationLocal.group
    }
}
