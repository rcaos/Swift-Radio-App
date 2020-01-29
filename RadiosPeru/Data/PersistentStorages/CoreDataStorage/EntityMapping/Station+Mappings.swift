//
//  Station+Mappings.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import CoreData

extension Station {
    
    convenience init(stationRemote: StationRemote, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = stationRemote.name
        self.image = stationRemote.image
        self.city = stationRemote.city
        self.frecuency = stationRemote.frecuency
        self.slogan = stationRemote.slogan
        self.urlStream = stationRemote.urlStream
        self.group = stationRemote.group
        self.groupId = stationRemote.groupId
        self.groupBase = stationRemote.groupBase
    }
}

extension StationRemote {
    
    init(stationLocal: Station) {
        name = stationLocal.name
        image = stationLocal.image
        city = stationLocal.city
        frecuency = stationLocal.frecuency
        slogan = stationLocal.slogan
        urlStream = stationLocal.urlStream
        
        group = stationLocal.group
        groupId = stationLocal.groupId
        groupBase = stationLocal.groupBase
    }
}