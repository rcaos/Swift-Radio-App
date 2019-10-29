//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MiniPlayerViewModel {
    
    private let showService = ApiClient<RadioShowProvider>()
    
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
    
    var updateUI:(()-> Void)?
    
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
    
    private func setupRadio(_ station: RadioStation) {
        radioStation = station
        name = radioStation.name
        defaultDescription = radioStation.city + " " +
                        radioStation.frecuency + " " +
                        radioStation.slogan
        //onlineDescription = "Currently Program.."
    }
    
    private func getShowDetail() {
        guard let radioStation = radioStation ,
            let idStation =  Int(radioStation.companyId) else { return }
        
        showService.load(service: .getNowShowDetail(idStation), decodeType: GrupoRPPResult.self , completion: { result in
            switch result {
            case .success(let response) :
                self.processFetched(for: response)
            case .failure(let error) :
                print(error)
            }
        })
    }
    
    private func processFetched(for response: GrupoRPPResult) {
        let radioDetail = response.results.radioDetail
        
        self.onlineDescription = radioDetail.name
        updateUI?()
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
        
        if viewState.value == .playing {
            getShowDetail()
        }
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String) {
        
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String) {
        
    }
}
