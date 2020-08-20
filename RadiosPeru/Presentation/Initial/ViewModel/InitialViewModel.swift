//
//  InitialViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

protocol InitialViewModelProtocol {
  
  func viewDidLoad()
}

final class InitialViewModel: InitialViewModelProtocol {
  
  private let fetchStationsUseCase: FetchStationsUseCase
  
  private let disposeBag = DisposeBag()
  
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
      .subscribe(onError: { error in
        print("error to Fetch Stations: [\(error)]")
      }, onDisposed: { [weak self] in
        self?.viewDidFinish()
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func viewDidFinish() {
    coordinator?.navigate(to: .initialSceneDidFinish)
  }
}
