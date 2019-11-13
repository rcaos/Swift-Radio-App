//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class PlayerViewModel {
    
    private var managedObjectContext: NSManagedObjectContext
    private var favoritesStore: PersistenceStore<StationFavorite>!
    
    private let showClient = ShowClient()
    private var radioPlayer: RadioPlayer?
    
    private var nameSelected: String!
    private var groupSelected: String!
    
    var image: String?
    
    var name: String?
    
    var defaultDescription: String?
    
    private var leftDefaultDescription: String?
    
    var onlineDescription: String?
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(() -> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(name: String, group: String, service: RadioPlayer?, managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
        setupStores(self.managedObjectContext)
        
        self.nameSelected = name
        self.groupSelected = group
        
        self.radioPlayer = service
        
        radioPlayer?.delegate = self
        setupRadio()
    }
    
    //MARK: - Private
    
    private func setupStores(_ managedObjectContext: NSManagedObjectContext) {
        favoritesStore = PersistenceStore(managedObjectContext)
    }
    
    private func setupRadio() {
        guard let radioStation = getSelectedStation() else { return }
        
        name = radioStation.name
        image = radioStation.image
        
        leftDefaultDescription = radioStation.city + " " +
            radioStation.frecuency + " "
        
        defaultDescription = (leftDefaultDescription ?? "")
            + " " + radioStation.slogan
        
        isFavorite.value = favoritesStore.isFavorite(with: radioStation.name, group: radioStation.group)
    }
    
    private func getSelectedStation() -> Station?{
        guard let name  = nameSelected, let _ = groupSelected,
            let selected = PersistenceManager.shared.findStation(with: name) else { return nil }
        return selected
    }
    
    //MARK: - Networking
    
    private func getShowDetail() {
        guard let radioStation = getSelectedStation() else { return }
        
        //MARK: - TODO
        showClient.getShowOnlineDetail(group: radioStation.type, completion: { result in
            switch result {
            case .success(let response) :
                guard let showResult = response else { return  }
                self.processFetched(for: showResult)
            case .failure(let error) :
                print(error)
            }
        })
    }
    
    private func processFetched(for radioResponse: Show) {
        self.onlineDescription = radioResponse.name
        updateUI?()
    }
    
    //MARK: - Public
    
    func togglePlayPause() {
        guard let player = radioPlayer else { return }
        player.togglePlayPause()
    }
    
    func markAsFavorite() {
        isFavorite.value = favoritesStore.toggleFavorite(with: nameSelected, group: groupSelected)
    }
    
    func refreshStatus() {
        guard let player = radioPlayer else { return }
        viewState.value = player.state
        
        if viewState.value == .playing {
            getShowDetail()
        }
    }
    
    func getDescription() -> String? {
        switch viewState.value {
        case .playing, .buffering:
            if let onlineDescription = onlineDescription,
                !onlineDescription.isEmpty {
                return (leftDefaultDescription ?? "") + " - " +
                onlineDescription
            } else {
                return defaultDescription
            }
        default:
            return defaultDescription
        }
    }
}

extension PlayerViewModel : RadioPlayerDelegate {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        print("Soy Delegate PlayerViewModel, recibo state: \(state)")
        viewState.value = state
        
        if viewState.value == .playing {
            getShowDetail()
        }
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String) {
        
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String) {
        
    }
}
