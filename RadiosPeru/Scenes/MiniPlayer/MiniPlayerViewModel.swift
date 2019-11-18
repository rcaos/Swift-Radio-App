//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import CoreData

final class MiniPlayerViewModel {
    
    private var managedObjectContext: NSManagedObjectContext
    private var favoritesStore: PersistenceStore<StationFavorite>!
    
    private let showClient = ShowClient()
    private var radioPlayer: RadioPlayer?
    
    private var nameSelected: String?
    private var groupSelected: String?
    
    var name: String = "Pick a Radio Station"
    
    var defaultDescription: String?
    
    var onlineDescription: String?
    
    var isSelected: Bool {
        guard let name  = nameSelected, let _ = groupSelected,
            let _ = PersistenceManager.shared.findStation(with: name) else { return false }
        return true
    }
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(()-> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(name: String?, group: String?, service: RadioPlayer?, managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
        setupStores(self.managedObjectContext)
        
        self.nameSelected = name
        self.groupSelected = group
        
        radioPlayer = service
        radioPlayer?.addObserver(self)
    }
    
    deinit {
        radioPlayer?.removeObserver(self)
    }
    
    private func setupStores(_ managedObjectContext: NSManagedObjectContext) {
        favoritesStore = PersistenceStore(managedObjectContext)
    }
    
    func configStation(by name: String, group: String, playAutomatically: Bool = true) {
        self.nameSelected = name
        self.groupSelected = group
        
        //MARK: - TODO, también necesitaría consultar + .group
        guard let station = getSelectedStation() else { return }
        
        setupRadio(station)
        
        viewState.value = .stopped
        radioPlayer?.setupRadio(with: station.urlStream, playWhenReady: playAutomatically)
    }
    
    func togglePlayPause() {
        guard let player = radioPlayer else { return }
        player.togglePlayPause()
    }
    
    func markAsFavorite() {
        guard let selected = getSelectedStation() else { return }
        isFavorite.value = favoritesStore.toggleFavorite(with: selected.name, group: selected.group)
    }
    
    func refreshStatus() {
        guard let player = radioPlayer else { return }
        viewState.value = player.state
        
        guard let selected = getSelectedStation() else { return }
        setupRadio( selected )
    }
    
    func getDescription() -> String? {
        switch viewState.value {
        case .playing, .buffering:
            if let onlineDescription = onlineDescription,
                !onlineDescription.isEmpty {
                return onlineDescription
            } else {
                return defaultDescription
            }
        case .error(let message):
            return message
        default:
            return defaultDescription
        }
    }
    
    //MARK: - Private
    
    private func setupRadio(_ radio: Station) {
        self.name = radio.name
        self.defaultDescription = radio.city + " " +
            radio.frecuency + " " +
            radio.slogan
        
        isFavorite.value = favoritesStore.isFavorite(with: radio.name, group: radio.group)
    }
    
    private func getShowDetail() {
        guard let selected = getSelectedStation() else { return }
        
        showClient.getShowOnlineDetail(group: selected.type , completion: { result in
            switch result {
            case .success(let response) :
                guard let showResult = response else { return }
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
    
    private func getSelectedStation() -> Station?{
        guard let name  = nameSelected, let _ = groupSelected,
            let selected = PersistenceManager.shared.findStation(with: name) else { return nil }
        return selected
    }
    
    //MARK: - View Models Building
    
    func buildPlayerViewModel() -> PlayerViewModel? {
        guard let name = self.nameSelected, let group = self.groupSelected else { return nil }
        
        return PlayerViewModel(name: name, group: group, service: radioPlayer, managedObjectContext: managedObjectContext)
    }
}

extension MiniPlayerViewModel: RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        print("Estoy suscrito MiniPlayerViewModel, recibo state: \(state)")
        viewState.value = state
        
        if case .playing = viewState.value {
            getShowDetail()
        }
    }
    
}
