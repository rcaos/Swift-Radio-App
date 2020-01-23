//
//  ApiClient.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

protocol ApiClient {
    var session: URLSession { get }
    
    func fetch<T: Decodable>(with request:  URLRequest,
                             context:       NSManagedObjectContext?,
                             decode:        @escaping (Decodable) -> T?,
                             completion:    @escaping (Result<T, APIError>) -> Void)
}

extension ApiClient {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest,
                                            decodingType: T.Type,
                                            context: NSManagedObjectContext?,
                                            completionHandler completion: JSONTaskCompletionHandler?) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion?(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.userInfo[.context] = context
                        let genericModel = try decoder.decode(decodingType, from: data)
                        try context?.save()
                        completion?(genericModel, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion?(nil, .requestFailed)
                    }
                } else {
                    completion?(nil, .invalidData)
                }
            } else {
                completion?(nil, APIError(response: httpResponse))
            }
        }
        return task
    }
    
    func fetch<T: Decodable>(with request: URLRequest,
                             context: NSManagedObjectContext? = nil,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T, APIError>) -> Void) {
        print("request: [\(request)]")
        let task = decodingTask(with: request, decodingType: T.self, context: context) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.requestFailed))
                    }
                    return
                }
                
                // Only if is Decodable
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.requestFailed))
                }
            }
        }
        task.resume()
    }
}
