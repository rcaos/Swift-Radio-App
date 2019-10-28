//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MiniPlayerViewModel {
    
    private var servicePlayer: RadioPlayer?
    
    private var radioStation: RadioStation!
    
    var name: String = "Pick a Radio Station"
    
    var defaultDescription: String?
    
    var onlineDescription: String?
    
    var isSelected: Bool {
        return (radioStation != nil)
    }
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    //MARK: - Initializers
    
    init(radio: RadioStation?, service: RadioPlayer?) {
        if let station = radio {
            setupRadio(station)
        }
        servicePlayer = service
        servicePlayer?.delegate = self
    }
    
    deinit {
        print("Finalizo Player ViewModel")
    }
    
    func configStation(radio: RadioStation, playAutomatically: Bool = true) {
        setupRadio(radio)
        viewState.value = .stopped
        servicePlayer?.setupRadio(with: radioStation, playWhenReady: playAutomatically)
    }
    
    func togglePlayPause() {
        guard let service = servicePlayer else { return }
        service.togglePlayPause()
    }
    
    func markAsFavorite() {
        print("Mark as Favorite..")
    }
    
    func refreshStatus() {
        guard let player = servicePlayer else { return }
        player.delegate = self
        viewState.value = player.state
    }
    
    //MARK: - Private
    
    private func setupRadio(_ station: RadioStation) {
        radioStation = station
        name = radioStation.name
        defaultDescription = radioStation.city + " " +
                        radioStation.frecuency + " " +
                        radioStation.slogan
        onlineDescription = "Currently Program.."
    }
 
    //MARK: - View Models Building
    
    func buildPlayerViewModel() -> PlayerViewModel {
        return PlayerViewModel(station: radioStation, service: servicePlayer)
    }
}

extension MiniPlayerViewModel : RadioPlayerDelegate {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        print("Soy Delegate MiniPlayerViewModel, recibo state: \(state)")
        viewState.value = state
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String) {
        
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String) {
        
    }
}
