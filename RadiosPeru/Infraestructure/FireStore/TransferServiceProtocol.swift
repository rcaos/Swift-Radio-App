//
//  TransferServiceProtocol.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/29/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol TransferServiceProtocol {
  
  func request<Element: Decodable>(path: String, type: Element.Type) -> Observable<[Element]>
  
  func save<Element: Encodable>(path: String, _ entitie: Element, _ id: String?) -> Observable<String>
}
