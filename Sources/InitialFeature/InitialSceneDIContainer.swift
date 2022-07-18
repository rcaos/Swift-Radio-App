import Domain
import NetworkingInterface
import UIKit

public final class InitialSceneDIContainer {

  public struct Dependencies {
    let dataTransferService: DataTransferService
//    let stationsLocalStorage: StationsLocalStorage

    public init(dataTransferService: DataTransferService) {
      self.dataTransferService = dataTransferService
    }
  }

  private let dependencies: Dependencies

  // MARK: - Initializers
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func buildInitialViewController(coordinator: InitialCoordinatorProtocol? = nil) -> UIViewController {
    return InitialViewController.create(with: makeInitialViewModel(coordinator: coordinator))
  }
}

// MARK: - Private
extension InitialSceneDIContainer {

  private func makeInitialViewModel(coordinator: InitialCoordinatorProtocol?) -> InitialViewModel {
    let initialVM = InitialViewModel(fetchStationsUseCase: makeFetchStationsUseCase())
    initialVM.coordinator = coordinator
    return initialVM
  }
  
  // MARK: - Use Cases
  
  private func makeFetchStationsUseCase() -> FetchStationsUseCase {
    return DefaultFetchStationsUseCase(
      stationsRemoteRepository: StationsRepository(dataTransferService: dependencies.dataTransferService)
//      ,
//      stationsLocalRepository: makeStationsLocalRepository()
    )
  }
//
//  // MARK: - Repositories
//  private func makeStationsRepository() -> StationsRepository {
//    return DefaultStationsRepository(dataTransferService: dependencies.dataTransferService)
//  }
//
//  private func makeStationsLocalRepository() -> StationsLocalRepository {
//    return DefaultStationsLocalRepository(stationsPersistentStorage: dependencies.stationsLocalStorage)
//  }
}

extension InitialSceneDIContainer: InitialCoordinatorDependencies { }
