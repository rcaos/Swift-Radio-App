import Combine
import Domain
import Foundation

protocol StationsLocalRepositoryProtocol { // MARK: - TODO, Use "Stations" only
  func saveStations(_ stations: [StationLocal]) -> AnyPublisher<Void, CustomError>

  func getAllStationList() -> AnyPublisher<[StationLocal], CustomError>

  /// Search if SimpleStationLocal exits on Repository
  func findStations(favorites: [SimpleStationLocal]) -> AnyPublisher<[StationLocal], CustomError>
}

struct SimpleStationLocal {
  public let name: String
  public let id: Int

  public init(name: String, id: Int) {
    self.name = name
    self.id = id
  }
}

struct StationLocal {
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

  public init(id: Int, name: String, order: Int, city: String, frecuency: String,
              slogan: String, urlStream: String, pathImage: String,
              group: String, groupId: String, groupBase: String, isActive: Bool) {
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
