//
//  StationsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol StationsRepository {
    
    func stationsList(completion: @escaping (Result<StationResult, Error>) -> Void) -> Cancellable?
}