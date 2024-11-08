//
//  NextToGoViewModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import NetworkingManager
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
    @Published private(set) var isLoading: Bool = true

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
        refresh() // Initial data load
    }

    // MARK: - Private Methods
    private func setupBindings() {
        interactor.nextToGoRacesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] raceData in
                guard let self = self else { return }
                // a sneaky little delay to add time to show skeleton loading ;-)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading = false
                    self.nextToGoDisplayModel.currentRaces = raceData
                    self.nextToGoDisplayModel.filterRaces(.all)
                }
            }
            .store(in: &cancellables)

        // TODO: - add error publisher 
        interactor.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: NetworkingErrors) {
        // Network Error
        switch error {
        case .invalidDecoding:
            print("Failed to decode the response.")
        case .invalidHTTPResponse:
            print("Invalid HTTP response.")
        case .serverError(let statusCode):
            print("Server error with status code: \(statusCode)")
        case .unknown:
            print("An unknown error occurred.")
        case .invalidURL:
            print("Invalid URL")
        }
    }

    // MARK: - Public Methods
    func refresh() {
        isLoading = true
        interactor.refreshData()
    }

    // Updates the filter from the view and triggers a layout change in the display model
    func updateFilter(to newFilter: NextToGoDisplayModel.FilterOption) {
        nextToGoDisplayModel.filterRaces(newFilter)
    }
}
