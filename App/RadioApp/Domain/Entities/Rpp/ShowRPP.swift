//
//  RadioShow.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct ShowRPP: Show {
    
    var id: String
    var name: String
    var imageURL: String
    
    var startTime: String
    var endTime: String
}

extension ShowRPP {
    
    var horario: String {
        return startTime + " - " + endTime
    }
}
