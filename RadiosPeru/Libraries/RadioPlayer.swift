//
//  RadioPlayer.swift
//  RadiosPeru
//
//  Created by Jeans on 10/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

//Visual States

enum RadioPlayerState {
    case stopped
    case loading
    case playing
    case buffering
    case error(String)
}

class RadioPlayer {
    
    var state: RadioPlayerState = .stopped
    
    private let player = ApiPlayer.shared
    
    private var observations = [ObjectIdentifier: Observation]()
    
    private let showClient = ShowClient()
    
    private var nameSelected: String?
    
    private var onlineInfo: String?
    
    private var dataSource: PlayerDataSource? {
        didSet {
            player.dataSource = dataSource
        }
    }
    
    //MARK: - Life Cycle
    
    init() {
        player.delegate = self
    }
    
    //MARK: - Publics
    func setupRadio(with station: String?, playWhenReady: Bool = false) {
        guard let stationSelected = getSelectedStation(with: station) else { return }
        nameSelected = station
        
        resetRadio()
        
        if let url = URL(string: stationSelected.urlStream) {
            player.prepare(with: url, playWhenReady: playWhenReady)
        }
        
        setupSource(with: stationSelected)
    }
    
    func refreshOnlineInfo() {
        getAiringNowDetails()
    }
    
    func togglePlayPause() {
        player.togglePlayPause()
    }
    
    func resetRadio() {
        player.stop()
        onlineInfo = nil
        //Clean DataSource
    }
    
    func getRadioDescription() -> String {
        
        guard let stationSelected = getSelectedStation(with: nameSelected) else { return "" }
        
        let defaultDescription = stationSelected.city + " - " +
            stationSelected.frecuency + " - " +
            stationSelected.slogan
        
        switch state {
        case .playing, .buffering:
            if let onlineDescription = onlineInfo, !onlineDescription.isEmpty {
                return stationSelected.city + " - " +
                        stationSelected.frecuency + " - " +
                        onlineDescription
            } else {
                return defaultDescription
            }
        case .error(let message):
            return message
        default:
            return defaultDescription
        }
    }
    
    func updateCurrentTrack() {
        //delegate?.didChangeTrack()
    }
    
    func updateTrackArt() {
        //delegate?.didChangeImage()
    }
    
    func resetTrackArt() {
        //Reset Image for Station
    }
    
    //MARK: - Private
    
    //func getImage(for station: RadioStation) {
        //Consulta imagen
    //}
    
    //MARK : - Networking
    
    private func getAiringNowDetails() {
        guard let stationSelected = getSelectedStation(with: nameSelected) else { return }
        
        showClient.getShowOnlineDetail(group: stationSelected.type, completion: { result in
            switch result {
            case .success(let response) :
                guard let showResult = response else { return }
                self.onlineInfo = showResult.name
                
                self.changeOnlineInfo()
                self.setupSource(with: stationSelected)
                
            case .failure(let error) :
                print("Error to get online Description: \(error)")
                self.onlineInfo = ""
                self.setupSource(with: stationSelected)
            }
        })
    }
    
    private func getSelectedStation(with name: String?) -> Station? {
        //MARK: - TODO
        //, let _ = groupSelected,
        guard let stationName = name,
            let station = PersistenceManager.shared.findStation(with: stationName) else { return nil }
        return station
    }
    
    private func setupSource(with selected: Station) {
        let defaultInfo = selected.city + " - " +
            selected.frecuency + " - " +
            selected.slogan
        
        dataSource = PlayerDataSource(title: selected.name, defaultInfo: defaultInfo, onlineNowInfo: self.onlineInfo, artWork: selected.image)
    }
}

extension RadioPlayer: ApiPlayerDelegate {
    
    func apiPlayerDelegate(didChangeState state: ApiPlayerState) {
        let radioState: RadioPlayerState
        
        switch state {
        case .playing :
            radioState = .playing
        case .buffering :
            radioState = .buffering
        case .preparing(_) :
            radioState = .loading
        case .error :
            radioState = .error("Error: Try another Radio")
        default :
            radioState = .stopped
        }
        print("Change ApiPlayer State: \(state). Informo con: \(radioState)")
        
        self.state = radioState
        
        stateDidChange(with: radioState)
        
        if case .playing = radioState {
            getAiringNowDetails()
        }
    }
}

private extension RadioPlayer {
    
    struct Observation {
        weak var observer: RadioPlayerObserver?
    }
}

//MARK: - Notify to all Observers

private extension RadioPlayer {
    
    func stateDidChange(with state: RadioPlayerState) {
        print("Informar a \(observations.count) suscriptores. didChangeState")
        for(id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.radioPlayer(self, didChangeState: state)
        }
    }
    
    func changeOnlineInfo( ) {
        print("Informar a \(observations.count) suscriptores. didChangeOnlineInfo")
        for(id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.radioPlayerDidChangeOnlineInfo(self)
        }
    }
}

//MARK: - Suscribe/ Unsuscribe

extension RadioPlayer {
    
    func addObserver(_ observer: RadioPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
        print("Nuevo suscriptor: \(id)")
    }
    
    func removeObserver(_ observer: RadioPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
        print("Se dió de baja a suscriptor: \(id)")
    }
}
