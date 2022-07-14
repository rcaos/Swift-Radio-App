//
//  FavoriteTableViewModel.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Domain

final class FavoriteTableViewModel {
  
  let radioStation: StationProp
  
  lazy var imageURL: URL? = {
    return URL(string: radioStation.pathImage)
  }()
  
  let titleStation: String?
  let detailStation: String?
  let isFavorite: Bool
  
  init(_ station: StationProp) {
    self.radioStation = station
    
    titleStation = station.name
    detailStation = station.slogan
    isFavorite = true
  }
}
