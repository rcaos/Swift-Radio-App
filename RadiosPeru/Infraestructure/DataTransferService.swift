//
//  DataTransferService.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public protocol DataTransferService {
    
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    func request<T: EndPoint> (service: T, completion: @escaping CompletionHandler<Data>) -> NetworkCancellable?
    
    func request<T: EndPoint, U: Decodable>(service: T, decodeType: U.Type, completion: @escaping CompletionHandler<U>) -> NetworkCancellable?
}

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }
