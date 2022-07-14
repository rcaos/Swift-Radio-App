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
  public let id: Int
  public let name: String
  public let order: Int
  public let city: String
  public let frecuency: String
  public let slogan: String
  public let urlStream: String
  public let pathImage: String

  public let group: String
  public let groupId: String
  public let groupBase: String

  public let isActive: Bool

  public init(
    id: Int,
    name: String,
    order: Int,
    city: String,
    frecuency: String,
    slogan: String,
    urlStream: String,
    pathImage: String,
    group: String,
    groupId: String,
    groupBase: String,
    isActive: Bool
  ) {
    self.id = id
    self.name =  name
    self.order =  order
    self.city =  city
    self.frecuency = frecuency
    self.slogan =  slogan
    self.urlStream = urlStream
    self.pathImage = pathImage
    self.group =  group
    self.groupId = groupId
    self.groupBase = groupBase
    self.isActive = isActive
  }
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
  public let type: String
  public let id: String
}

public struct CRP {
  public let type: String
  public let base: String
}
