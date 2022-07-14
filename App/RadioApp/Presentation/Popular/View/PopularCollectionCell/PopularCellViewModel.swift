//
//  PopularViewCellViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Domain
import Foundation

final class PopularCellViewModel {
  
  let radioStation: StationProp
  
  lazy var imageURL: URL? = {
    return URL(string: radioStation.pathImage)
  }()
  
  init(_ station: StationProp) {
    radioStation = station
  }
  
}
