//
//  PopularViewCellViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Domain
import Foundation

struct PopularCellViewModel: Hashable {
  let radioStation: StationProp
  let imageURL: URL?

  init(_ station: StationProp) {
    radioStation = station
    imageURL = URL(string: radioStation.pathImage)
  }
}
