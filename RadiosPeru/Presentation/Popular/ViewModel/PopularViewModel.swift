//
//  PopularViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

protocol PopularViewModelDelegate: class {
    
    func stationDidSelect(station: StationRemote)
}

final class PopularViewModel {
    
    private let fetchStationsUseCase: FetchStationsLocalUseCase
    
    private var stations: [StationRemote] = []
    
    var popularCells: [PopularCellViewModel] = []
    
    var viewState: Bindable<ViewState> = Bindable(.empty)
    
    private weak var delegate: PopularViewModelDelegate?
    
    init(fetchStationsUseCase: FetchStationsLocalUseCase, delegate: PopularViewModelDelegate? = nil) {
        self.fetchStationsUseCase = fetchStationsUseCase
        self.delegate = delegate
    }
    
    func getStations() {
        let request = FetchStationsLocalUseCaseRequestValue()
        
        _ = fetchStationsUseCase.execute(requestValue: request) { [weak self] result in
            switch result {
            case .success(let items):
                self?.processFetched(for: items)
            case .failure:
                break
            }
        }
    }
    
    private func processFetched(for items: [StationRemote]) {
        stations = items
        
        popularCells = stations.map({
            PopularCellViewModel(station: $0)
        })
        
        if popularCells.isEmpty {
            viewState.value = .empty
        } else {
            viewState.value = .populated
        }
    }
    
    func getStationSelection(by index: Int) {
        delegate?.stationDidSelect(station: stations[index])
    }
}

extension PopularViewModel {
    
    enum ViewState {
        
        case populated
        case empty
        
    }
}
