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

protocol RadioPlayerDelegate: class {
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String)
}

class RadioPlayer {
    
    private let player = ApiPlayer.shared
    
    private var urlStation: String?
    
    weak var delegate: RadioPlayerDelegate? {
        didSet {
            print("Cambia delegate de RadioPlayer")
        }
    }
    
    var state: RadioPlayerState = .stopped
    
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
        
        delegate?.radioPlayer(self, didChangeState: radioState)
    }
}
