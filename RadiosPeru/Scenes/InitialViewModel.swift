//
//  InitialViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class InitialViewModel {
    
    private let stationClient = StationsClient()
    
    var stationsFetched: (() -> Void)?
    
    private var managedObjectContext: NSManagedObjectContext!
    
    init(managedObjectContext: NSManagedObjectContext = PersistenceManager.shared.mainContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    //MARK: - Public
    
    public func getStations() {
        stationClient.getAllStations( context: managedObjectContext, completion: { result in
            switch result {
            case .success(let stationsResult):
                print("Se recibieron: \(stationsResult?.stations.count) stations del Backend")
            case .failure(_):
                print("error to Fetch Stations del Backend")
            }
            
            self.stationsFetched?()
        })
    }
}
