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
    
    func refreshData()
}

final class NextoGoInteractor: NextToGoInteractorProtocol {
    // Network Service
    private let networkService: NetworkServiceProtocol
    // AnyCancellable to manage memory for Combine subscriptions
    private var cancellables: Set<AnyCancellable> = []
    // Timer to refresh data every 60 seconds
    private var refreshTimerID: UUID?
    // Refresh timer
    // TODO: - formalise this value
    private let refreshInterval: TimeInterval = 60
    // A TimerManager for handling count down timing on races
    private let timerManager: CentralTimerManager
    // Published Race data
    @Published var nextToGoRaces: RaceData?
    
    var nextToGoRacesPublisher: AnyPublisher<RaceData?, Never> {
        $nextToGoRaces.eraseToAnyPublisher()
    }
    
    init(
        networkService: NetworkServiceProtocol,
        timerManager: CentralTimerManager = CentralTimerManager.shared
    ) {
        self.networkService = networkService
        self.timerManager = timerManager
    }
    
    public func refreshData() {
        Task {
            do {
                try await self.fetchNextToGoFromServer()
            } catch {
                self.handleError(error)
            }
        }
    }
    
    /// Fetches "Next To Go" data from the server asynchronously
    /// - Throws: An error if the network request fails
    private func fetchNextToGoFromServer() async throws {
        // Sends a network request to fetch "Next To Go" data, expecting a `RaceData` response
        networkService.performRequest(
            endpoint: .nextToGo(10),
            type: RaceData.self
        )
        .sink(
            receiveCompletion: { completion in
                // Handles the completion of the request
                switch completion {
                case .finished:
                    // Handle successful completion if needed.
                    break
                case .failure(let error):
                    // Handle errors by passing them to the `handleError` function
                    self.handleError(error)
                }
            },
            receiveValue: { [weak self] data in
                guard let self else { return }
                print("Received data")
                self.nextToGoRaces = data
            }
        )
        .store(in: &cancellables)
    }
    
    // MARK: - Private methods
    
    private func startDataRefreshTimer() {
        // Start a repeating timer using CentralTimerManager
        refreshTimerID = timerManager.addTimer(duration: refreshInterval)
        
        // Subscribe to timer updates
        timerManager.$timers
            .compactMap { [weak self] timers in
                self?.refreshTimerID.flatMap { timers[$0] }
            }
            .filter { $0.remainingTime <= 1 }
            .sink { [weak self] _ in
                Task {
                    do {
                        try await self?.fetchNextToGoFromServer()
                    } catch {
                        self?.handleError(error)
                    }
                }
                // Reset the timer
                if let refreshTimerID = self?.refreshTimerID {
                    self?.timerManager.resetTimer(
                        for: refreshTimerID,
                        duration: self?.refreshInterval ?? 60
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    /// Handles network-related errors and provides specific error messages
    /// - Parameter error: The error encountered during the network request
    private func handleError(_ error: Error) {
        // TODO: - Handle error with using cached data, and informing the user
        // Casts the error to `NetworkingErrors` to handle specific cases
        if let networkingError = error as? NetworkingErrors {
            switch networkingError {
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
        } else {
            // Handles other types of errors not related to networking
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// Deinitializes the timer
    deinit {
        if let refreshTimerID = refreshTimerID {
            timerManager.removeTimer(for: refreshTimerID)
        }
    }
}
