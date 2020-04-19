//
//  LocalClient.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/18/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class LocalClient {
  
  private let pathLocalFile: String
  private let extensionLocalFile: String
  
  init(pathLocalFile: String, extensionLocalFile: String) {
    self.pathLocalFile = pathLocalFile
    self.extensionLocalFile = extensionLocalFile
  }
}

extension LocalClient: DataTransferService {
  
  func request<Element>(_ router: EndPoint, _ type: Element.Type) -> Observable<Element>
    where Element: Decodable {
    
    if let filePathURL = Bundle.main.url(
      forResource: self.pathLocalFile,
      withExtension: self.extensionLocalFile) {
      do {
        let data = try Data(contentsOf: filePathURL)
        
        let decoder = JSONDecoder()
        
        let resp = try decoder.decode(Element.self, from: data)
        return Observable.just(resp)
      } catch {
        return Observable.error(error)
      }
    } else {
      return Observable.empty()
    }
  }
}
