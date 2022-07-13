//
//  EndPoint.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public protocol EndPoint {
  
  var baseURL: String { get }
  
  var path: String { get }
  
  var parameters: [String: Any]? { get }
  
  var method: ServiceMethod { get }
}

extension EndPoint {
  
  var urlRequest: URLRequest {
    guard let url = self.url else {
      fatalError("URL could not be built")
    }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    return request
  }
  
  private var url: URL? {
    var urlComponents = URLComponents(string: baseURL)
    urlComponents?.path = path
    
    var queryItems: [URLQueryItem] = []
    
    if let params = parameters, method == .get {
      queryItems.append(contentsOf: params.map({
        return URLQueryItem(name: "\($0)", value: "\($1)")
      }))
    }
    
    urlComponents?.queryItems = queryItems
    return urlComponents?.url
  }
}

public enum ServiceMethod: String {
  case get = "GET"
  // implement more when needed: post, put, delete, patch, etc.
}
