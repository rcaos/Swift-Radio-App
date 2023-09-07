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
    nowInfoRepository: RadioStationInfoRepository
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

// MARK: - Data Source
import Networking

struct RadioStationInfoRPPRemoteDataSource {
  var getNowInfo: (_ radioId: String) async throws -> RadioStationRPPDTO
}

struct RadioStationRPPDTO: Decodable {
  let results: ResultDTO

  struct ResultDTO: Decodable {
    let pi: PI

    enum CodingKeys: String, CodingKey {
      case pi = "PI"
    }

    struct PI: Decodable {
      let description: String
    }
  }

  func toDomain() -> RadioStationNowInfo {
    return .init(description: results.pi.description)
  }
}

extension RadioStationInfoRPPRemoteDataSource {
  static func live(apiClient: ApiClient) -> RadioStationInfoRPPRemoteDataSource {
    return RadioStationInfoRPPRemoteDataSource(getNowInfo: {
      let endpoint = Endpoint(path: "now/live", method: .get, queryParameters: ["rpIds": $0])
      return try await apiClient.apiRequest(endpoint: endpoint, as: RadioStationRPPDTO.self)
    })
  }
}

// MARK: - Repository
struct RadioStationInfoRepository {
  var getNowInfo: (_ radioStatio: RadioStation) async throws -> RadioStationNowInfo
}

extension RadioStationInfoRepository {
  static func live(
    rppDataSource: RadioStationInfoRPPRemoteDataSource
  ) -> RadioStationInfoRepository {
    return RadioStationInfoRepository(getNowInfo: {
      switch $0.type {
      case .RPP:
        return try await rppDataSource.getNowInfo($0.id).toDomain()
      case .other:
        return .init(description: "Online")
      }
    })
  }
}

// MARK: - DI
public func factoryUseCase(apiClient: ApiClient) -> FetchNowInfoUseCase {
  let datasource = RadioStationInfoRPPRemoteDataSource.live(apiClient: apiClient)
  let repo = RadioStationInfoRepository.live(rppDataSource: datasource)
  let useCase = FetchNowInfoUseCase.live(nowInfoRepository: repo)
  return useCase
}
