//
//  DataTransferService.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol DataTransferService {
  func request<Element: Decodable>(_ router: EndPoint, _ type: Element.Type) -> Observable<Element>
}
