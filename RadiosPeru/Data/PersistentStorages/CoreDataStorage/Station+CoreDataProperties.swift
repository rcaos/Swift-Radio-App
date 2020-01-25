//
//  Station+CoreDataProperties.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

extension Station {

    // Lo crea xCode ??
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }
}
