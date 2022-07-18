import Combine
import Domain
import Networking
import NetworkingInterface
import Shared

protocol StationsRemoteRepositoryProtocol {
  func fetchAllStations() -> AnyPublisher<[StationRemote], CustomError>
}

struct StationsDTO: Decodable {
  let stations: [StationRemote]  // MARK: - TODO, use another domain model DTO and Domain
}

struct StationsRepository: StationsRemoteRepositoryProtocol {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
  
  func fetchAllStations() -> AnyPublisher<[StationRemote], CustomError> {
    let endPoint = Endpoint<StationsDTO>(
      path: "s/t5b5nqxxro5a9tu/stations-20200413.json",
      method: .get,
      queryParameters: ["dl": 1]
    )
    return dataTransferService.request(with: endPoint)
      .map(\.stations)
      .mapError { transferError in
        return CustomError.transferError(transferError)
      }
      .eraseToAnyPublisher()
  }
}
