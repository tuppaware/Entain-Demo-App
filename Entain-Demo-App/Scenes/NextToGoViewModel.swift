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
    private(set) var raceData: RaceData?
    
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
                self.raceData = raceData
                self.isLoading = false
                self.nextToGoDisplayModel.currentRaces = raceData
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
    
    private func subscribeToTimers() {
        // Monitor all timers in CentralTimerManager
        timerManager.$timers
            .sink { [weak self] timers in
                self?.updateActiveTimers(with: timers)
            }
            .store(in: &cancellables)
    }
    
    // TODO: - refactor to something nicer
    private func updateActiveTimers(with timers: [UUID: TimerItem]) {
        let timerIds = timers.filter { (0...1).contains($0.value.remainingTime) }.map { $0.key }
        // retrigger displayModel
        if !timerIds.isEmpty {
            self.nextToGoDisplayModel.currentRaces = raceData
        }
    }

    // MARK: - Public Methods
    func refresh() {
        isLoading = true
        interactor.refreshData()
    }

    func updateFilter(to newFilter: NextToGoDisplayModel.FilterOption) {
        nextToGoDisplayModel.filter = newFilter
    }
}
