//
//  Show.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

protocol Show {
    
    var id: String { get }
    
    var name: String { get }
    
    var imageURL: String { get }
    
    var horario: String { get }
}
