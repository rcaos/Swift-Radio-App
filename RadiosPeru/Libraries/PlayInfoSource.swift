//
//  PlayInfoSource.swift
//  RadiosPeru
//
//  Created by Jeans on 11/15/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

public protocol PlayInfoSource {
    
    var url: String { get }
    
    var title: String { get }
    
    var defaultInfo: String { get }
    
    var onlineInfo: String? { get }
    
    var artWork: UIImage? { get }
    
}

extension PlayInfoSource {
    
    func nowPlayInfo(image: UIImage? = nil) -> [String: Any] {
        var info:[String: Any] = [:]
        
        info[MPMediaItemPropertyTitle] = title
        info[MPMediaItemPropertyArtist] = defaultInfo
        
        if let online = onlineInfo {
            info[MPMediaItemPropertyAlbumTitle] = online
        }
        
        return info
    }
}
