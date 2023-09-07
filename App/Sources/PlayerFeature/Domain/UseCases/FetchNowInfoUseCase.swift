//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 5/09/23.
//

import Foundation

public struct FetchNowInfoUseCase {
  public var execute: (RadioStation) async -> RadioStationNowInfo
}

extension FetchNowInfoUseCase {
  static func live(
    nowInfoRepository: RadioStationNowInfoRepository
  ) -> FetchNowInfoUseCase {
    return FetchNowInfoUseCase(execute: {
      do {
        return try await nowInfoRepository.getNowInfo($0)
      } catch  {
        return .init(description: "Error")
      }
    })
  }
}
