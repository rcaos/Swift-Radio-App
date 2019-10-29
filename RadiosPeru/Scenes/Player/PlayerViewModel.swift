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
    
    private let radioClient = RadioClient()
    
    private var servicePlayer: RadioPlayer?
    
    private var radioStation: RadioStation
    
    var image: String?
    
    var name: String?
    
    var defaultDescription: String?
    
    var onlineDescription: String?
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(() -> Void)?
    
    //MARK: - Initializers
    
    init(station: RadioStation, service: RadioPlayer?) {
        self.radioStation = station
        self.servicePlayer = service
        servicePlayer?.delegate = self
        setupRadio(for: station)
    }
    
    //MARK: - Private
    
    private func setupRadio(for station: RadioStation) {
        name = radioStation.name
        image = radioStation.image
        defaultDescription = radioStation.city + " " +
                        radioStation.frecuency + " " +
                        radioStation.slogan
    }
    
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
        guard let service = servicePlayer else { return }
        service.togglePlayPause()
    }
    
    func markAsFavorite() {
        print("Mark as Favorite..")
    }
    
    func refreshStatus() {
        guard let service = servicePlayer else { return }
        viewState.value = service.state
        
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
