import Domain
import Combine
import Foundation

protocol InitialViewModelProtocol {
  func viewDidLoad()
}

final class InitialViewModel: InitialViewModelProtocol {
  private let fetchStationsUseCase: FetchStationsUseCase
  private var disposeBag = Set<AnyCancellable>()
  weak var coordinator: InitialCoordinatorProtocol?

  // MARK: - Initializers
  init(fetchStationsUseCase: FetchStationsUseCase) {
    self.fetchStationsUseCase = fetchStationsUseCase
  }

  deinit {
    print("deinit \(Self.self)")
  }

  // MARK: - Public
  public func viewDidLoad() {
    let request = FetchStationsUseCaseRequestValue()

    fetchStationsUseCase.execute(requestValue: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] _ in
        self?.viewDidFinish()
      },
            receiveValue: { list in
        print("rcaos list= \n \(list)")
      })
      .store(in: &disposeBag)
  }

  private func viewDidFinish() {
    coordinator?.navigate(to: .initialSceneDidFinish)
  }
}
