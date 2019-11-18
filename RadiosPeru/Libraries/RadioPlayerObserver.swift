//
//  RadioPlayerObserver.swift
//  RadiosPeru
//
//  Created by Jeans on 11/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

protocol RadioPlayerObserver: class {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState)
    
    func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String)
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String)
}

extension RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) { }
    
    func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) { }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String) { }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String) { }
}
