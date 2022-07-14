//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 14/07/22.
//

// MARK: - TODO, clean this
import Foundation

public struct StationProp: Equatable {

  public let id: Int
  public let name: String
  public let city: String
  public let frecuency: String
  public let slogan: String
  public let urlStream: String
  public let pathImage: String
  public let type: Group

  public init(_ station: StationRemote) {
    id = station.id
    name = station.name
    city = station.city
    frecuency = station.frecuency
    slogan = station.slogan
    urlStream = station.urlStream
    pathImage = station.pathImage
    type = station.type
  }

  public static func == (lhs: StationProp, rhs: StationProp) -> Bool {
    return lhs.id == rhs.id
  }
}

public struct StationRemote: Equatable {
  let id: Int
  let name: String
  let order: Int
  let city: String
  let frecuency: String
  let slogan: String
  let urlStream: String
  let pathImage: String

  let group: String
  let groupId: String
  let groupBase: String

  let isActive: Bool
}

extension StationRemote {
  var type: Group {
    if group == "rpp" {
      return .rpp( RPP(type: self.group, id: self.groupId) )
    } else if group == "crp" {
      return .crp( CRP(type: self.group, base: self.groupBase) )
    } else {
      return .unknown
    }
  }
}

public enum Group {
  case rpp(RPP)
  case crp(CRP)
  case unknown
}

public struct RPP {
  let type: String
  let id: String
}

public struct CRP {
  let type: String
  let base: String
}
