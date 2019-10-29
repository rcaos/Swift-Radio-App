//
//  RadioShowProvider.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum GroupRPPProvider {
    case getNowShowDetail(String)
}

//MARK: - EndPoint

extension GroupRPPProvider: EndPoint {
    var baseURL: String {
        return "https://radio.rpp.pe"
    }
    
    var path: String {
        return "/now/live"
    }
    
    var parameters: [String:Any]? {
        var params: [String: Any] = [:]
        
        switch self {
        case .getNowShowDetail(let id):
            params["rpIds"] = id
        }
        
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
