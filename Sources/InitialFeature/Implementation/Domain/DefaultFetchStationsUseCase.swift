import Domain
import Combine
import Networking
import NetworkingInterface
import Shared

protocol FetchStationsUseCase {
  func execute(requestValue: FetchStationsUseCaseRequestValue) -> AnyPublisher<[StationRemote], CustomError>
}

struct FetchStationsUseCaseRequestValue {
  public init() { }
}

struct DefaultFetchStationsUseCase: FetchStationsUseCase {

  private let stationsRemoteRepository: StationsRemoteRepositoryProtocol
  //  private let stationsLocalRepository: StationsLocalRepository

  public init(stationsRemoteRepository: StationsRemoteRepositoryProtocol
              //              , stationsLocalRepository: StationsLocalRepository
  ) {
    self.stationsRemoteRepository = stationsRemoteRepository
    //    self.stationsLocalRepository = stationsLocalRepository
  }

  // MARK: - TODO, save in Local Repository
  public func execute(requestValue: FetchStationsUseCaseRequestValue)-> AnyPublisher<[StationRemote], CustomError> {
    return stationsRemoteRepository.fetchAllStations()
    //      .flatMap { stations -> Observable<[StationRemote]> in
    //        self.stationsLocalRepository.saveStations(stations: stations)
    //          .flatMap { _ -> Observable<[StationRemote]> in
    //            return Observable.just(stations)
    //        }
    //    }
  }
}
