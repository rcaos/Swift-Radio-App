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
  
  var title: String { get }
  
  var defaultInfo: String { get }
  
  var onlineNowInfo: String? { get }
  
  var artWork: String? { get }
  
}

extension PlayInfoSource {
  
  func nowPlayInfo() -> [String: Any] {
    var info: [String: Any] = [:]
    
    info[MPMediaItemPropertyTitle] = title
    
    if let online = onlineNowInfo {
      info[MPMediaItemPropertyArtist] = online
    }
    
    info[MPMediaItemPropertyAlbumTitle] = defaultInfo

    // MARK: - TODO, recover this
//    if let named = artWork, let urlImage = URL(string: named) {
//      let imageView = UIImageView()
//      imageView.setImage(with: urlImage)
//
//      if let image = imageView.image {
//        let imageArtWork = MPMediaItemArtwork(boundsSize: image.size) { _ -> UIImage in
//          return image
//        }
//        info[MPMediaItemPropertyArtwork] = imageArtWork
//      }
//    }
    
    return info
  }
  
  func nowDefaultInfo() -> [String: Any] {
    var info: [String: Any] = [:]
    
    info[MPMediaItemPropertyTitle] = title
    info[MPMediaItemPropertyArtist] = defaultInfo
    
    if let named = artWork, let image = UIImage(named: named) {
      let imageArtWork = MPMediaItemArtwork(boundsSize: image.size) { _ -> UIImage in
        return image
      }
      info[MPMediaItemPropertyArtwork] = imageArtWork
    }
    
    return info
  }
}

struct PlayerDataSource: PlayInfoSource {
  
  var title: String
  
  var defaultInfo: String
  
  var onlineNowInfo: String?
  
  var artWork: String?
}
