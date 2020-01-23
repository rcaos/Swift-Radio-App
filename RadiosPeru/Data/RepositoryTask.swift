//
//  RepositoryTask.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct RepositoryTask: Cancellable {
    
    let networkTask: NetworkCancellable?
    
    func cancel() {
        networkTask?.cancel()
    }
}
