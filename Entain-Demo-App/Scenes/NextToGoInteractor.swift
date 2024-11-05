//
//  NextToGoInteractor.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import Combine

/// Protocol defining the requirements for the Next To Go interactor
protocol NextToGoInteractorProtocol: AnyObject {
    /// Race data from the API
    var nextToGoRaces: RaceData? { get }
    
    func refreshData()
}

@Observable
final class NextoGoInteractor: NextToGoInteractorProtocol {
    // Network Service
    @ObservationIgnored private let networkService: NetworkServiceProtocol
    // AnyCancellable to manage memory for Combine subscriptions
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    // Timer to refresh data every 60 seconds
    @ObservationIgnored private var refreshTimer: Timer?
    // Published Race data
    var nextToGoRaces: RaceData?
    
    /// Initializes a new instance of `NextoGoInteractor`
    /// - Parameter networkService: A `NetworkServiceProtocol` to handle network operations
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        startDataRefreshTimer()
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
            endpoint: .nextToGo(5),
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
                    // Processes and prints the received data
                    print("Received data: \(data)")
                    self?.nextToGoRaces = data
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private methods
    
    /// Starts a timer to refresh server data every 60 seconds
    private func startDataRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(
            withTimeInterval: 60,
            repeats: true
        ) { [weak self] _ in
            Task {
                do {
                    try await self?.fetchNextToGoFromServer()
                } catch {
                    self?.handleError(error)
                }
            }
        }
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
        refreshTimer?.invalidate()
    }
}
