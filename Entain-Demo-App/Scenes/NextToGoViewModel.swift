//
//  NextToGoViewModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import Combine

protocol NextToGoViewModelProtocol: ObservableObject {
    var nextToGoDisplayModel: NextToGoDisplayModel { get }
    var isLoading: Bool { get }
    func refresh()
    func updateFilter(to newFilter: NextToGoDisplayModel.FilterOption)
}

class NextToGoViewModel: NextToGoViewModelProtocol {
    // MARK: - Published Properties
    @Published var nextToGoDisplayModel: NextToGoDisplayModel
    @Published private(set) var isLoading: Bool = false

    // MARK: - Private Properties
    private let interactor: NextToGoInteractorProtocol
    private var cancellables = Set<AnyCancellable>()
    private let timerManager: CentralTimerManager
    
    // MARK: - Initialization
    init(
        interactor: NextToGoInteractorProtocol,
        timerManager: CentralTimerManager = CentralTimerManager.shared
    ) {
        self.interactor = interactor
        self.timerManager = timerManager
        self.nextToGoDisplayModel = NextToGoDisplayModel(timerManager: timerManager)
        setupBindings()
        // subscribeToTimers()
        refresh() // Initial data load
    }

    // MARK: - Private Methods
    private func setupBindings() {
        interactor.nextToGoRacesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] raceData in
                guard let self = self else { return }
                self.isLoading = false
                self.nextToGoDisplayModel.currentRaces = raceData
                self.nextToGoDisplayModel.filterRaces(.all)
            }
            .store(in: &cancellables)

        // Optional: Handle errors if interactor publishes them
        // TODO: - add error publisher 
//        if let errorPublisher = interactor.errorPublisher {
//            errorPublisher
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] error in
//                    self?.isLoading = false
//                    // Handle the error (e.g., set an error message)
//                }
//                .store(in: &cancellables)
//        }
    }


    // MARK: - Public Methods
    func refresh() {
        isLoading = true
        interactor.refreshData()
    }

    func updateFilter(to newFilter: NextToGoDisplayModel.FilterOption) {
        nextToGoDisplayModel.filterRaces(newFilter)
    }
}
