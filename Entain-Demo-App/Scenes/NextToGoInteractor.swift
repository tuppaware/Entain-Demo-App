//
//  NextToGoInteractor.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import Combine
import NetworkingManager

/// Protocol defining the requirements for the Next To Go interactor
protocol NextToGoInteractorProtocol: AnyObject {
    /// Race data from the API
    var nextToGoRaces: RaceData? { get }

    var nextToGoRacesPublisher: AnyPublisher<RaceData?, Never> { get }
    
    var errorPublisher: AnyPublisher<NetworkingErrors, Never> { get }
    
    func refreshData()
}

final class NextoGoInteractor: NextToGoInteractorProtocol {
    // Network Service
    private let networkService: NetworkServiceProtocol
    // AnyCancellable to manage memory for Combine subscriptions
    private var cancellables: Set<AnyCancellable> = []
    // Timer to refresh data
    private var refreshTimer: Timer?
    // Refresh interval
    private let refreshInterval: TimeInterval = 60
    // A TimerManager for handling count down timing on races
    private let timerManager: CentralTimerManager
    // Published Race data
    @Published var nextToGoRaces: RaceData?
    // Error publisher
    private let errorSubject = PassthroughSubject<NetworkingErrors, Never>()
    
    var nextToGoRacesPublisher: AnyPublisher<RaceData?, Never> {
        $nextToGoRaces.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<NetworkingErrors, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(
        networkService: NetworkServiceProtocol,
        timerManager: CentralTimerManager = CentralTimerManager.shared
    ) {
        self.networkService = networkService
        self.timerManager = timerManager
    }
    
    public func refreshData() {
        // Start the data fetching process
        fetchNextToGoFromServer()
    }
    
    /// Fetches "Next To Go" data from the server and sets up a timer to refresh data
    private func fetchNextToGoFromServer() {
        // Cancel any existing timer
        refreshTimer?.invalidate()
        refreshTimer = nil
        
        // Sends a network request to fetch "Next To Go" data, expecting a `RaceData` response
        // Bumped results to 30, so that we can get a larger range of races in a category
        // Handy if a category of races starts soon but would be bumped by more races in other categories.
        networkService.performRequest(
            endpoint: .nextToGo(20),
            type: RaceData.self
        )
        .sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                // Handles the completion of the request
                switch completion {
                case .finished:
                    // Schedule the next fetch after refreshInterval seconds
                    self.refreshTimer = Timer.scheduledTimer(
                        withTimeInterval: self.refreshInterval,
                        repeats: false
                    ) { [weak self] _ in
                        self?.fetchNextToGoFromServer()
                    }
                case .failure(let error):
                    // Handle errors by passing them to the `handleError` function
                    self.handleError(error)
                }
            },
            receiveValue: { [weak self] data in
                guard let self = self else { return }
                print("Received data")
                self.nextToGoRaces = data
            }
        )
        .store(in: &cancellables)
    }
    
    // MARK: - Private methods
    
    /// Handles network-related errors and provides specific error messages
    /// - Parameter error: The error encountered during the network request
    private func handleError(_ error: Error) {
        // Cast to Network Error
        if let networkingError = error as? NetworkingErrors {
            errorSubject.send(networkingError)
        } else {
            // Handles other types of errors not related to networking
            print("Error: \(error.localizedDescription)")
        }
        
        // Schedule the next fetch after refreshInterval seconds even if there's an error
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.fetchNextToGoFromServer()
        }
    }
    
    deinit {
        // We are using [weak self] in the timer's closure to avoid retain cycles,
        // it's good practice to clean up any timers or observers when they are no longer needed.
        refreshTimer?.invalidate()
        refreshTimer = nil
        // Cancel all Combine subscriptions
        cancellables.forEach { $0.cancel() }
    }
}
