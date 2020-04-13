//
//  InitialViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class InitialViewModel {
  
  private let fetchStationsUseCase: FetchStationsUseCase
  
  var stationsFetched: (() -> Void)?
  
  var loadTask: Cancellable? {
    willSet {
      loadTask?.cancel()
    }
  }
  
  init(fetchStationsUseCase: FetchStationsUseCase) {
    self.fetchStationsUseCase = fetchStationsUseCase
  }
  
  // MARK: - Public
  
  public func getStations() {
    let request = FetchStationsUseCaseRequestValue()
    
    loadTask = fetchStationsUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      
      switch result {
      case .success: break
        
      case .failure(let error):
        print("error to Fetch Stations: [\(error)]")
      }
      
      strongSelf.stationsFetched?()
    }
  }
}
