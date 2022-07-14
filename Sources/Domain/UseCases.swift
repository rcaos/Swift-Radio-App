//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 14/07/22.
//

// MARK: - TODO, clean this
import Foundation
import RxSwift

public protocol FetchShowOnlineInfoUseCase {
  func execute(requestValue: FetchShowOnlineInfoUseCaseRequestValue) -> Observable<Show>
}

public struct FetchShowOnlineInfoUseCaseRequestValue {
  let group: Group

  public init(group: Group) {
    self.group = group
  }
}

public struct Event {
  let radioId: Int
  let radioName: String
  let urlStream: String
  let description: String
  let date: Date
  var uuid: String?

  public init(radioId: Int, radioName: String, urlStream: String, description: String, date: Date, uuid: String?) {
    self.radioId = radioId
    self.radioName = radioName
    self.urlStream = urlStream
    self.description = description
    self.date = date
    self.uuid = uuid
  }
}

public struct EventPlay {
  public let stationName: String
  public let start: Date
  public let end: Date

  public var seconds: Int {
    return Int(end.timeIntervalSince(start))
  }

  public static var empty: EventPlay {
    return EventPlay(stationName: "", start: Date(), end: Date())
  }

  var asDictionary: [String: Any] {
    return [
      "station_name": stationName,
      "seconds": seconds
    ]
  }

  public init(stationName: String, start: Date, end: Date) {
    self.stationName = stationName
    self.start = start
    self.end = end
  }
}

public protocol Show {
  var id: String { get }
  var name: String { get }
  var imageURL: String { get }
  var horario: String { get }
}
