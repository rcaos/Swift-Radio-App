//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit

final class PlayerViewModel {
    
    private let radioClient = ShowClient()
    
    private var radioPlayer: RadioPlayer?
    
    private var radioStation: RadioStation
    
    private var stationsManager: StationsManager
    
    var image: String?
    
    var name: String?
    
    var defaultDescription: String?
    
    var onlineDescription: String?
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(() -> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(station: RadioStation, service: RadioPlayer?, manager: StationsManager) {
        self.radioStation = station
        self.radioPlayer = service
        self.stationsManager = manager
        radioPlayer?.delegate = self
        setupRadio(for: station)
    }
    
    //MARK: - Private
    
    private func setupRadio(for station: RadioStation) {
        if let selected = stationsManager.findStation(for: station) {
            radioStation = selected
        } else {
            return
        }
        
        name = radioStation.name
        image = radioStation.image
        defaultDescription = radioStation.city + " " +
                        radioStation.frecuency + " " +
                        radioStation.slogan
        isFavorite.value = radioStation.isFavorite
    }
    
    //MARK: - Networking
    
    private func getShowDetail() {
        radioClient.getShowOnlineDetail(group: radioStation.group, completion: { result in
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
                return radioStation.city + " " +
                    radioStation.frecuency + " - " +
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
