//
//  PopularViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularViewModel {
    
    private let fetchStationsUseCase: FetchStationsLocalUseCase
    
    var popularCells: [PopularCellViewModel] = []
    
    var selectedRadioStation: ((String, String) -> Void)?
    
    var viewState: Bindable<ViewState> = Bindable(.empty)
    
    init(fetchStationsUseCase: FetchStationsLocalUseCase) {
        self.fetchStationsUseCase = fetchStationsUseCase
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
        popularCells = items.map({
            PopularCellViewModel(station: $0)
        })
        
        if popularCells.isEmpty {
            viewState.value = .empty
        } else {
            viewState.value = .populated
        }
    }
    
    func getStationSelection(by index: Int) {
//        let stations = PersistenceManager.shared.stations
//        let selectedStation = stations[index]
//        selectedRadioStation?( selectedStation.name, selectedStation.group )
    }
    
}

extension PopularViewModel {
    
    enum ViewState {
        
        case populated
        case empty
        
    }
}
