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
    
    private var radioPlayer: RadioPlayer?
    
    private var nameSelected: String!
    private var groupSelected: String!
    
    var image: String?
    
    var name: String?
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(() -> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(name: String, group: String, player: RadioPlayer?, managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
        setupStores(self.managedObjectContext)
        
        self.nameSelected = name
        self.groupSelected = group
        
        self.radioPlayer = player
        radioPlayer?.addObserver(self)
        
        setupRadio()
    }
    
    deinit {
        radioPlayer?.removeObserver(self)
    }
    
    //MARK: - Private
    
    private func setupStores(_ managedObjectContext: NSManagedObjectContext) {
        favoritesStore = PersistenceStore(managedObjectContext)
    }
    
    private func setupRadio() {
        guard let radioStation = getSelectedStation() else { return }
        
        name = radioStation.name
        image = radioStation.image
        
        isFavorite.value = favoritesStore.isFavorite(with: radioStation.name, group: radioStation.group)
    }
    
    private func getSelectedStation() -> Station?{
        guard let name  = nameSelected, let _ = groupSelected,
            let selected = PersistenceManager.shared.findStation(with: name) else { return nil }
        return selected
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
        
        if case .playing = viewState.value {
            player.refreshOnlineInfo()
        }
    }
    
    func getDescription() -> String {
        guard let radioPlayer = radioPlayer else { return "" }
        
        return radioPlayer.getRadioDescription()
    }
}

//MARK: - RadioPlayerObserver

extension PlayerViewModel : RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        viewState.value = state
    }
    
    func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
        updateUI?()
    }
    
}
