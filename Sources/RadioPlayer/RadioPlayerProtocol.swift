//
//  RadioPlayerProtocol.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Domain

public protocol RadioPlayerProtocol {
  // MARk: - Input
  func setupRadio(with station: StationProp, playWhenReady: Bool)
  func togglePlayPause()
  
  // MARK: - Output
  var statePlayer: Observable<RadioPlayerState> { get }
  var airingNow: Observable<String> { get }
}

// MARK: - Visual States

public enum RadioPlayerState: Equatable {
  
  case stopped
  case loading
  case playing
  case buffering
  case error(String)
}
