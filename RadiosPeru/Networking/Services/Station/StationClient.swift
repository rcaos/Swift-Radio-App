//
//  StationClient.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

class StationClient: ApiClient {
    
    let session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func getAllStations(context: NSManagedObjectContext, completion: @escaping(Result<StationResult?, APIError>) -> Void ) {
        
        let request = StationProvider.getAll.urlRequest
        
        fetch(with: request, context: context,
              decode: { json -> StationResult? in
                guard let stationResult = json as? StationResult else {
                    return nil
                }
                return stationResult },
              completion: completion)
    }
}
