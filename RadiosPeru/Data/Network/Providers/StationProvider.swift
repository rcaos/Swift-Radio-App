//
//  StationProvider.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum StationProvider {
    
    case getAll
    
}

//MARK: - EndPoint

//https://www.dropbox.com/s/95idd63yx1r5jn7/stationsNew.json?dl=1

extension StationProvider: EndPoint {
    
    var baseURL: String {
        return "https://www.dropbox.com"
    }
    
    var path: String {
        return "/s/95idd63yx1r5jn7/stationsNew.json"
    }
    
    var parameters: [String : Any]? {
        var params: [String: Any] =  [:]
        params["dl"] = 1
        
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
