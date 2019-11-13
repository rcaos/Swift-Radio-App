//
//  PersistenceManager.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    lazy var persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RadiosPeru")
        container.loadPersistentStores(completionHandler: { _, error in
            guard error == nil else { fatalError()
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        let context = persistenceContainer.viewContext
        context.mergePolicy = NSMergePolicy.overwrite
        return context
    }
    
    private var stationStore: PersistenceStore<Station>!
    
    //MARK: - Initializers
    
    private init() {
        setupStores()
    }
    
    //MARK: - Private
    
    private func setupStores() {
        stationStore = PersistenceStore(mainContext)
    }
    
    //MARK: - Stations
    
    var stations: [Station] {
        return stationStore.findAll()
    }
    
    func findStation(with name: String) -> Station? {
        return stations.filter { $0.name == name}.first
    }
    
    var favorites: [Station] {
        return stationStore.findFavorites()
    }
}
