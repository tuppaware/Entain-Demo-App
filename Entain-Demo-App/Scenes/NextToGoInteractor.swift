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
@MainActor
protocol NextToGoInteractorProtocol: AnyObject {
    /// Race data from the API, holding the latest races information
    var nextToGoRaces: RaceData? { get }
    
    /// Publisher for next-to-go race data updates
    var nextToGoRacesPublisher: AnyPublisher<RaceData?, Never> { get }
    
    /// Publisher for error updates
    var errorPublisher: AnyPublisher<NetworkingErrors, Never> { get }
    
    /// Triggers a data refresh by fetching new race data
    func refreshData()
}

/// Interactor class for managing and refreshing "Next To Go" race data
@MainActor
final class NextToGoInteractor: NextToGoInteractorProtocol, ObservableObject {
    // MARK: - Properties
    
    /// Network service used to perform network requests
    private let networkService: NetworkServiceProtocol
    
    /// Timer instance to periodically refresh race data
    private var refreshTimer: Timer?
    
    /// Time interval for refreshing data automatically (in seconds)
    private let refreshInterval: TimeInterval = 60
    
    /// TimerManager instance to handle countdown timing on races
    private let timerManager: TimerManager
    
    /// Published property holding the latest race data
    @Published var nextToGoRaces: RaceData?
    
    /// Subject for publishing errors encountered during data fetch
    private let errorSubject = PassthroughSubject<NetworkingErrors, Never>()
    
    /// Publisher exposing next-to-go race data updates for external subscribers
    var nextToGoRacesPublisher: AnyPublisher<RaceData?, Never> {
        $nextToGoRaces.eraseToAnyPublisher()
    }
    
    /// Publisher exposing errors for external subscribers
    var errorPublisher: AnyPublisher<NetworkingErrors, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    /// Initializes the NextToGoInteractor with a network service and timer manager
    /// - Parameters:
    ///   - networkService: The network service used to fetch race data
    ///   - timerManager: Timer manager for handling countdowns, defaults to shared instance
    init(
        networkService: NetworkServiceProtocol,
        timerManager: TimerManager = TimerManager.shared
    ) {
        self.networkService = networkService
        self.timerManager = timerManager
    }
    
    // MARK: - Public Methods
    
    /// Public method to start the data refresh process
    func refreshData() {
        // Initiates fetching of the next-to-go races from the server
        fetchNextToGoFromServer()
    }
    
    // MARK: - Private Methods
    
    /// Fetches "Next To Go" data from the server and sets up a timer to periodically refresh data
    private func fetchNextToGoFromServer() {
        // Cancel any active refresh timer to prevent overlap
        refreshTimer?.invalidate()
        refreshTimer = nil
        
        // Start an asynchronous task to perform the network request
        Task {
            do {
                // Perform the async network request using async/await
                let data = try await networkService.performRequest(
                    endpoint: .nextToGo(20),
                    type: RaceData.self
                )
                
                // Update the published race data
                // Want to really make sure the publisher is run from main thread.
                await MainActor.run {
                    print("new data recieved")
                    self.nextToGoRaces = data
                }
                
                // Schedule the next fetch after `refreshInterval` seconds
                self.scheduleNextFetch()
            } catch let networkingError as NetworkingErrors {
                // Handle known networking errors
                self.handleError(networkingError)
            } catch {
                // Handle unknown errors by mapping to `.unknown`
                self.handleError(.unknown)
            }
        }
    }
    
    /// Schedules the next data fetch after the specified interval.
    private func scheduleNextFetch() {
        // Schedule the next fetch after `refreshInterval` seconds.
        self.refreshTimer = Timer.scheduledTimer(
            withTimeInterval: self.refreshInterval,
            repeats: false
        ) { [weak self] _ in
            guard let self = self else { return }
            // Initiate an asynchronous task to call the @MainActor-isolated method.
            Task { [weak self] in
                await self?.fetchNextToGoFromServer()
            }
        }
    }
    
    /// Handles network-related errors and schedules the next data fetch
    /// - Parameter error: The error encountered during the network request
    private func handleError(_ error: NetworkingErrors) {
        // Publish the error to subscribers
        errorSubject.send(error)
        
        // Schedule the next fetch after `refreshInterval` seconds even if there's an error
        self.scheduleNextFetch()
    }
    
    /// Cleans up timers to prevent memory leaks
    deinit {
        // Invalidate and remove any active refresh timer
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
