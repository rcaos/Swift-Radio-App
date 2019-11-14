//
//  FavoritesViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class FavoritesViewModel {
    
    private var favoriteStore: PersistenceStore<StationFavorite>!
    
    var stations: [PopularCellViewModel] {
        let favoriteStations = PersistenceManager.shared.favorites
        return favoriteStations.map({ PopularCellViewModel(station: $0) })
    }
    
    var selectedRadioStation: ((String, String) -> Void)?
    
    //Reactive
    var viewState: Bindable<ViewState> = Bindable(.empty)
    
    init(managedObjectContext: NSManagedObjectContext) {
        setupStores(managedObjectContext)
        refreshStations()
    }
    
    private func setupStores(_ managedObjectContext: NSManagedObjectContext) {
        favoriteStore = PersistenceStore(managedObjectContext)
        favoriteStore.configureResultsController(sortDescriptors: StationFavorite.defaultSortDescriptors)
        favoriteStore.delegate = self
    }
    
    private func refreshStations() {
        if stations.count == 0 {
            viewState.value = .empty
        } else {
            viewState.value = .populated
        }
    }
    
    //MARK: - Public Methods
    
    func getStationSelection(by index: Int) {
        let favorites = PersistenceManager.shared.favorites
        let selectedStation = favorites[index]
        selectedRadioStation?( selectedStation.name, selectedStation.group)
    }
}

//MARK: - PersistenceStoreDelegate

extension FavoritesViewModel: PersistenceStoreDelegate {
    
    func persistenceStore(didUpdateEntity update: Bool) {
        refreshStations()
    }
}

extension FavoritesViewModel {
    
    enum ViewState {
        
        case populated
        case empty
        
    }
}
