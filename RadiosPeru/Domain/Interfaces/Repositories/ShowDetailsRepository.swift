//
//  ShowDetailsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol ShowDetailsRepository {
    
    func fetchShowDetails(group: Group, completion: @escaping (Result<Show, Error>) -> Void) -> Cancellable?
}
