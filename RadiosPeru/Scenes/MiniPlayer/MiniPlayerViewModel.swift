//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import CoreData

final class MiniPlayerViewModel {
    
//    private var managedObjectContext: NSManagedObjectContext
//    private var favoritesStore: PersistenceStore<StationFavorite>!
    
    private var radioPlayer: RadioPlayer?
    
    private var nameSelected: String?
    private var groupSelected: String?
    
    var name: String = "Pick a Radio Station"
    
    // MARK: - TODO
    var isSelected: Bool {
//        guard let name  = nameSelected, let _ = groupSelected,
//            let _ = PersistenceManager.shared.findStation(with: name) else { return false }
        return true
    }
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(()-> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(name: String?, group: String?, service: RadioPlayer?) {
        
//        self.managedObjectContext = managedObjectContext
        //setupStores(self.managedObjectContext)
        
        self.nameSelected = name
        self.groupSelected = group
        
        radioPlayer = service
        radioPlayer?.addObserver(self)
    }
    
    deinit {
        radioPlayer?.removeObserver(self)
    }
    
    private func setupStores(_ managedObjectContext: NSManagedObjectContext) {
//        favoritesStore = PersistenceStore(managedObjectContext)
    }
    
    //MARK: - Public
    
    func configStation(by name: String, group: String, playAutomatically: Bool = true) {
        self.nameSelected = name
        self.groupSelected = group
        
        //MARK: - TODO, también necesitaría consultar + .group
        guard let station = getSelectedStation() else { return }
        
        setupRadio(station)
        
        viewState.value = .stopped
        radioPlayer?.setupRadio(with: name, playWhenReady: playAutomatically)
    }
    
    func togglePlayPause() {
        guard let player = radioPlayer else { return }
        player.togglePlayPause()
    }
    
    func markAsFavorite() {
        guard let selected = getSelectedStation() else { return }
//        isFavorite.value = favoritesStore.toggleFavorite(with: selected.name, group: selected.group)
    }
    
    func refreshStatus() {
        guard let player = radioPlayer else { return }
        viewState.value = player.state
        
        guard let selected = getSelectedStation() else { return }
        setupRadio( selected )
    }
    
    func getDescription() -> String {
        guard let radioPlayer = radioPlayer else { return "" }
        
        return radioPlayer.getRadioDescription()
    }
    
    //MARK: - Private
    
    private func setupRadio(_ radio: Station) {
        self.name = radio.name
        
//        isFavorite.value = favoritesStore.isFavorite(with: radio.name, group: radio.group)
    }
    
    private func getSelectedStation() -> Station?{
//        guard let name  = nameSelected, let _ = groupSelected,
//            let selected = PersistenceManager.shared.findStation(with: name) else { return nil }
//        return selected
        
        return nil
    }
    
    //MARK: - View Models Building
    
    func buildPlayerViewModel() -> PlayerViewModel? {
        guard let name = self.nameSelected, let group = self.groupSelected else { return nil }
        
        return PlayerViewModel(name: name, group: group, player: radioPlayer)
    }
}


//MARK: - RadioPlayerObserver

extension MiniPlayerViewModel: RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        viewState.value = state
    }
    
    func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
        updateUI?()
    }
    
}
