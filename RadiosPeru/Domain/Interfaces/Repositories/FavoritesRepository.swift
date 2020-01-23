//
//  FavoritesRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FavoritesRepository {
    
    // MARK: - TODO change String by Entities
    
    func favoritesList(completion: @escaping (Result<[String], Error>) -> Void)
    
    func saveAsFavorite(station: String,
                        completion: @escaping (Result<String, Error>) -> Void)
}
