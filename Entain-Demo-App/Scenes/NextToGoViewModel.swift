//
//  NextToGoViewModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import Observation
import Combine

protocol NextToGoViewModelProtocol {
    var nextToGoDisplayModel: NextToGoDisplayModel { get set }
}

@Observable
class NextToGoViewModel: NextToGoViewModelProtocol {
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    private let interactor: NextToGoInteractorProtocol
    var isLoading: Bool = false
    var nextToGoDisplayModel: NextToGoDisplayModel
    
    init(interactor: NextToGoInteractorProtocol) {
        self.interactor = interactor
        self.nextToGoDisplayModel = .init(filter: .all)
    }
    
    // Computed property to observe interactor's nextToGoRaces
    var currentRaces: RaceData? {
        interactor.nextToGoRaces
    }
    
    // Function to update the display model when interactor's data changes
    func updateDisplayModel() {
        nextToGoDisplayModel.currentRaces = interactor.nextToGoRaces
    }
    
    func refresh() {
        cancellables.removeAll()
        interactor.refreshData()
    }
}
