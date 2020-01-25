//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class MainViewModel {
    
//    private var managedObjectContext: NSManagedObjectContext
    
    var miniPlayer: MiniPlayerViewModel
    
    var radioPlayer: RadioPlayer
    
    init(radioPlayer: RadioPlayer) {
//        self.managedObjectContext = managedObjectContext
        
        self.radioPlayer = radioPlayer
        
        miniPlayer = MiniPlayerViewModel(name: nil, group: nil, service: radioPlayer)
    }
    
    func selectStation(by name: String, group: String) {
        miniPlayer.configStation(by: name, group: group)
    }
    
    //MARK: - Builds Model
    
    func buildPopularViewModel() -> PopularViewModel {
        return PopularViewModel()
    }
    
    func buildFavoriteViewModel() -> FavoritesViewModel {
        return FavoritesViewModel()
    }
}
