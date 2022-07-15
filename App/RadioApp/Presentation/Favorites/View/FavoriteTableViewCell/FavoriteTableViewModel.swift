//
//  FavoriteTableViewModel.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Domain

struct FavoriteTableViewModel: Hashable {
  let radioStation: StationProp
  let imageURL: URL?
  let titleStation: String?
  let detailStation: String?
  let isFavorite: Bool
  
  init(_ station: StationProp) {
    self.radioStation = station

    imageURL = URL(string: radioStation.pathImage)
    titleStation = station.name
    detailStation = station.slogan
    isFavorite = true
  }
}
