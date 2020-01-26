//
//  FavoritesLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FavoritesLocalStorage {
    
    func isFavorite(station: SimpleStation,
    completion: @escaping (Result<Bool, Error>) -> Void)
    
    func toogleFavorite(station: SimpleStation,
    completion: @escaping (Result<Bool, Error>) -> Void)
    
    func favoritesList(completion: @escaping (Result<[SimpleStation], Error>) -> Void)
}
