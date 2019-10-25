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
}

protocol RadioPlayerDelegate: class {
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String)
}

class RadioPlayer {
    
    private let player = ApiPlayer.shared
    
    weak var delegate: RadioPlayerDelegate?
    
    var station: RadioStation? {
        didSet {
            setupRadio(with: station)
        }
    }
    
    //MARK: - Life Cycle
    init() {
        //player.delegate = self
    }
    
    func setupRadio(with station: RadioStation?) {
        guard let station = station else { return }
        //TODO 
    }
    
    func resetRadioPlayer() {
        station = nil
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
        print("Cambio Player: \(state)")
        
        let radioState: RadioPlayerState
        
        switch state {
        case .playing :
            radioState = .playing
        case .buffering :
            radioState = .buffering
        case .preparing(_) :
            radioState = .loading
        default :
            radioState = .stopped
        }
        print("Cambio Player: \(state). Informo con: \(radioState)")
        
        delegate?.radioPlayer(self, didChangeState: radioState)
    }
}
