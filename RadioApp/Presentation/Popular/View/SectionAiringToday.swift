//
//  SectionAiringToday.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/15/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

struct SectionAiringToday {
  var header: String
  var items: [Item]
}

extension SectionAiringToday: SectionModelType {
  
  typealias Item = PopularCellViewModel
  
  init(original: SectionAiringToday, items: [Item]) {
    self = original
    self.items = items
  }
}
