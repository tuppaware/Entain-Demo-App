//
//  NextToGoViewModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import NetworkingManager
import Combine

/// Protocol defining the requirements for the NextToGo view model.
@MainActor
protocol NextToGoViewModelProtocol: ObservableObject {
    /// Display model containing filtered race data and options
    var nextToGoDisplayModel: NextToGoDisplayModel { get }
    
    /// Indicates if data is currently being loaded
    var isLoading: Bool { get }
    
    /// Initiates a data refresh
    func refresh() async
    
    /// Updates the filter option for displaying races
    /// - Parameter newFilter: The new filter option to apply
    func updateFilter(to newFilter: NextToGoDisplayModel.FilterOption)
}

/// View model for the NextToGo view, managing data fetching, filtering, and loading states.
@MainActor
class NextToGoViewModel: NextToGoViewModelProtocol {
    // MARK: - Published Properties
    
    /// Display model containing race data and filtering options
    @Published var nextToGoDisplayModel: NextToGoDisplayModel
    
    /// Indicates whether data is currently being loaded
    @Published private(set) var isLoading: Bool = true
    
    /// Error State
    @Published private(set) var errorMessage: String = ""
    
    // MARK: - Private Properties
    
    /// Interactor for fetching race data
    private let interactor: NextToGoInteractorProtocol
    
    /// Set of AnyCancellable instances to manage memory for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Timer manager for handling countdown timers on races
    private let timerManager: TimerManager
    
    /// Default reference to stored filter option
    private var filteredOption: NextToGoDisplayModel.FilterOption = .all
    
    // MARK: - Initialization
    
    /// Initializes the view model with an interactor and timer manager
    /// - Parameters:
    ///   - interactor: The interactor responsible for data fetching
    ///   - timerManager: Manages timers for race countdowns; defaults to a shared instance
    init(
        interactor: NextToGoInteractorProtocol,
        timerManager: TimerManager = TimerManager.shared
    ) {
        self.interactor = interactor
        self.timerManager = timerManager
        self.nextToGoDisplayModel = NextToGoDisplayModel(timerManager: timerManager)
        setupBindings()
        Task {
            await refresh() // Trigger an initial data load
        }
    }
    
    // MARK: - Private Methods
    
    /// Sets up bindings for receiving data and error updates from the interactor
    private func setupBindings() {
        // default filter state
        // Subscribe to race data updates from the interactor
        interactor.nextToGoRacesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] raceData in
                guard let self = self else { return }
                // Adds a slight delay to show the loading skeleton
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    self.nextToGoDisplayModel.currentRaces = raceData
                    // update filter 
                    self.updateFilter(to: self.filteredOption)
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to error updates from the interactor
        interactor.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }
    
    /// Handles networking errors received from the interactor
    /// - Parameter error: The specific networking error encountered
    private func handleError(_ error: NetworkingErrors) {
        // Print an error message based on the error type
        switch error {
        case .invalidDecoding:
            errorMessage = "Failed to decode the response."
        case .invalidHTTPResponse:
            errorMessage = "Invalid HTTP response."
        case .serverError(let statusCode):
            errorMessage = "Server error with status code: \(statusCode)"
        case .unknown:
            errorMessage = "An unknown error occurred."
        case .invalidURL:
            errorMessage = "Invalid URL"
        }
    }
    
    // MARK: - Public Methods
    
    /// Initiates a data refresh by invoking the interactor to fetch new data
    func refresh() async {
        // clear loading and error states 
        errorMessage = ""
        isLoading = true
        interactor.refreshData()
    }
    
    /// Updates the display filter based on the selected filter option
    /// - Parameter newFilter: The filter option to apply for race data
    func updateFilter(to newFilter: NextToGoDisplayModel.FilterOption) {
        filteredOption = newFilter
        nextToGoDisplayModel.filterRaces(newFilter)
    }
}
