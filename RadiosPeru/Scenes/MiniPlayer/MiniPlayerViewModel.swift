//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MiniPlayerViewModel {
    
    private let radioClient = RadioClient()
    
    private var radioPlayer: RadioPlayer?
    
    private var radioStation: RadioStation!
    
    private var stationsManager: StationsManager
    
    var name: String = "Pick a Radio Station"
    
    var defaultDescription: String?
    
    var onlineDescription: String?
    
    var isSelected: Bool {
        return (radioStation != nil)
    }
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(()-> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(radio: RadioStation?, service: RadioPlayer?, manager: StationsManager) {
        stationsManager = manager
        
        setupRadio(radio)
        
        radioPlayer = service
        radioPlayer?.delegate = self
    }
    
    deinit {
        print("Finalizo Player ViewModel")
    }
    
    func configStation(radio: RadioStation, playAutomatically: Bool = true) {
        setupRadio(radio)
        viewState.value = .stopped
        radioPlayer?.setupRadio(with: radioStation, playWhenReady: playAutomatically)
    }
    
    func togglePlayPause() {
        guard let player = radioPlayer else { return }
        player.togglePlayPause()
    }
    
    func markAsFavorite() {
        stationsManager.toggleFavorite(for: radioStation, completion: { result in
            switch result {
            case .success(let data) :
                self.isFavorite.value = data
            case .failure(_) :
                print("Error")
            }
        })
    }
    
    func refreshStatus() {
        guard let player = radioPlayer else { return }
        player.delegate = self
        viewState.value = player.state
        
        setupRadio(radioStation)
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
        default:
            return defaultDescription
        }
    }
    
    //MARK: - Private
    
    private func setupRadio(_ station: RadioStation?) {
        if let station = station,
            let selected = stationsManager.findStation(for: station) {
            radioStation = selected
        } else {
            return
        }
        
        name = radioStation.name
        defaultDescription = radioStation.city + " " +
                        radioStation.frecuency + " " +
                        radioStation.slogan
        isFavorite.value = radioStation.isFavorite
    }
    
    private func getShowDetail() {
        guard let radioStation = radioStation else { return }
        
        radioClient.getShowOnlineDetail(group: radioStation.group , completion: { result in
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
 
    //MARK: - View Models Building
    
    func buildPlayerViewModel() -> PlayerViewModel {
        return PlayerViewModel(station: radioStation, service: radioPlayer, manager: stationsManager)
    }
}

extension MiniPlayerViewModel : RadioPlayerDelegate {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        print("Soy Delegate MiniPlayerViewModel, recibo state: \(state)")
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
