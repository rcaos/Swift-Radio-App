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

protocol RadioPlayerObserver: class {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String)
}

extension RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) { }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String) { }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String) { }
}

class RadioPlayer {
    
    private let player = ApiPlayer.shared
    
    private var urlStation: String?
    
    var state: RadioPlayerState = .stopped
    
    private var observations = [ObjectIdentifier: Observation]()
    
    //MARK: - Life Cycle
    
    init() {
        player.delegate = self
    }
    
    //MARK: - Publics
    func setupRadio(with station: String?, playWhenReady: Bool = false) {
        guard let url = station else { return }
        
        resetRadio()
        self.urlStation = url
        
        if let urlStream = URL(string: url) {
            player.prepare(with: urlStream, playWhenReady: playWhenReady)
        }
    }
    
    func togglePlayPause() {
        player.togglePlayPause()
    }
    
    func resetRadio() {
        urlStation = nil
        player.stop()
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
    func getImage(for station: RadioStation) {
        //Consulta imagen
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
        for(id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.radioPlayer(self, didChangeState: state)
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
