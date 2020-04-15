//
//  Group.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum Group {
    case rpp(RPP)
    
    case crp(CRP)
}

struct RPP {
    let type: String
    let id: String
}

struct CRP {
    let type: String
    let base: String
}
