//
//  ApiClientNew.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

class ApiClient {
    
    //private let configuration: NetworkConfigurable
    
//    init(with configuration: NetworkConfigurable) {
//        self.configuration = configuration
//    }
}

// MARK: - DataTransferService

extension ApiClient: DataTransferService {
    
    func request<T>(service: T,
                    completion: @escaping CompletionHandler<Data>) -> NetworkCancellable?
        where T: EndPoint {
            
        let task = request(service.urlRequest) { result in
            switch result {
            case .success(let data):
                completion( .success(data) )
            case .failure(let error):
                completion( .failure(error) )
            }
        }
        return task
    }
    
    func request<T,U>(service: T,
                      decodeType: U.Type,
                      completion: @escaping CompletionHandler<U>) -> NetworkCancellable?
        where T: EndPoint, U: Decodable {
            
        let task = request(service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    completion(.success(resp))
                }
                catch {
                    print("error to Decode: [\(error)]")
                    completion(.failure( error ))
                }
            case .failure(let error):
                print("error server: [\(error)]")
                completion(.failure(error))
            }
        }
        return task
    }
}

// MARK: - Private

extension ApiClient {
    
    private func request(_ request: URLRequest,
                         deliverQueue: DispatchQueue = DispatchQueue.main,
                         completion: @escaping (Result<Data, APIError>) -> Void) -> NetworkCancellable {
        print( "url request new : [\(request)]" )
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                deliverQueue.async {
                    completion( .failure(.requestFailed) )
                }
                return
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                if let data = data {
                    deliverQueue.async {
                        completion( .success( data ))
                    }
                } else {
                    deliverQueue.async {
                        completion( .failure(  .invalidData ))
                    }
                }
            } else {
                deliverQueue.async {
                    completion( .failure( APIError(response: httpResponse) ))
                }
            }
        }
        task.resume()
        return task
    }
}
