//
//  NetworkConfigurable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/15/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import NetworkingInterface

public struct ApiDataNetworkConfig: NetworkConfigurable {

  public let baseURL: URL

  public let headers: [String: String]

  public let queryParameters: [String: String]

  public init(baseURL: URL,
              headers: [String: String] = [:],
              queryParameters: [String: String] = [:]) {
    self.baseURL = baseURL
    self.headers = headers
    self.queryParameters = queryParameters
  }
}
