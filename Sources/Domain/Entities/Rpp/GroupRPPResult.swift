//
//  GrupoRPPResponse.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct GroupRPPResult {
  public let results: ShowWrapper
}

public struct ShowWrapper {
  public let radioDetail: ShowRPP
}
