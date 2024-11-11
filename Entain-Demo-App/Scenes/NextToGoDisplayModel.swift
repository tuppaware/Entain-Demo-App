//
//  NextToGoDisplayModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import SharedUI
import SwiftUI
import Combine

/// The display model for the Next To Go view.
final class NextToGoDisplayModel: ObservableObject {
    /// Filtering options used in the Segment Control.
    enum FilterOption: String, CaseIterable, TabRepresentable {
        case all = "All"
        case greyhoundRacing = "Greyhound"
        case horseRacing = "Horse"
        case harnessRacing = "Harness"
        
        var id: String { rawValue }
        
        var categoryID: String {
            return raceCategory.rawValue
        }
    
        var raceCategory: RaceCategory {
            switch self {
            case .all: return .all
            case .greyhoundRacing: return .greyhoundRacing
            case .horseRacing: return .horseRacing
            case .harnessRacing: return .harnessRacing
            }
        }
        
        var displayTitle: String {
            rawValue
        }
        
        var displayIcon: Image? {
            switch self {
            case .all:
                return nil
            case .greyhoundRacing:
                return Image(.greyhoundFilter)
            case .horseRacing:
                return Image(.horseFilter)
            case .harnessRacing:
                return Image(.harnessFilter)
            }
        }
    }
    
    // Store of all the current races
    @Published var currentRaces: RaceData?
    
    // Filtered races list to be displayed
    @Published var filteredRacesListDisplayModel: [RaceItemViewModel] = []
    
    // Central Timer Manager for managing timers
    private let timerManager: TimerManager
    
    // Store for Combine subscriptions to handle memory management
    private var cancellables: Set<AnyCancellable> = []
    
    // Track active timers by their UUID to manage their lifecycles
    private var activeTimers: Set<UUID> = []
    
    /// Initializes the display model with a given timer manager.
    /// - Parameter timerManager: The manager responsible for handling race countdown timers.
    init(timerManager: TimerManager = TimerManager.shared) {
        self.timerManager = timerManager
    }
    
    /// Provides all filter options for the Segment Control display in the UI.
    var allFilterDisplayModel: CustomSegmentedDisplayModel<FilterOption> {
        CustomSegmentedDisplayModel(tabs: FilterOption.allCases)
    }
    
    /// Filters the races based on the selected filter option.
    /// - Parameter filterOption: The selected filter to apply to the races.
    func filterRaces(_ filterOption: FilterOption) {
        // Clear existing timers and subscriptions
        clearTimersAndSubscriptions()
        
        // Perform processing on background thread
        // Noting: This is likely overkill in this situation, but I'm just signifing that I'm aware of processing this on main thread ;)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            // Get race summaries
            guard let races = currentRaces?.data?.raceSummaries.values else { return }
            
            // Step 1: Filter races based on the selected filter
            var filteredRaces = getFilteredRaces(from: Array(races), filterOption: filterOption)
            
            // Step 2: Ensure at least 5 races are displayed
            filteredRaces = ensureMinimumRaceCount(filteredRaces, from: Array(races), minimumCount: 5)
            
            // Step 3: Create timers and view models
            let raceItemViewModels = createRaceItemViewModels(from: filteredRaces)
            
            DispatchQueue.main.async {
                // Step 4: Update the filtered race list for the UI
                self.filteredRacesListDisplayModel = raceItemViewModels
            }
        }
    }
    
    /// Clears existing timers and subscriptions.
    private func clearTimersAndSubscriptions() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        for timerID in activeTimers {
            timerManager.removeTimer(for: timerID)
        }
        activeTimers.removeAll()
    }
    
    /// Filters races based on the selected filter option.
    private func getFilteredRaces(from races: [RaceSummary], filterOption: FilterOption) -> [RaceSummary] {
        return races.filter { race in
            !race.advertisedStart.seconds.isInPast &&
            (filterOption == .all || race.categoryId == filterOption.categoryID)
        }
        .sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
    }
    
    /// Ensures at least a minimum number of races are available.
    private func ensureMinimumRaceCount(_ races: [RaceSummary], from allRaces: [RaceSummary], minimumCount: Int) -> [RaceSummary] {
        var filteredRaces = races
        if filteredRaces.count < minimumCount {
            let missingCount = minimumCount - filteredRaces.count
            let additionalRaces = allRaces.filter { race in
                !filteredRaces.contains(where: { $0.raceId == race.raceId }) && !race.advertisedStart.seconds.isInPast
            }
            .sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
            .prefix(missingCount)
            
            filteredRaces.append(contentsOf: additionalRaces)
        }
        return Array(filteredRaces.prefix(minimumCount))
    }
    
    /// Creates RaceItemViewModels and sets up timers.
    private func createRaceItemViewModels(from races: [RaceSummary]) -> [RaceItemViewModel] {
        return races.map { race in
            let remainingInterval = race.advertisedStart.seconds - Date().timeIntervalSince1970
            let timerID = timerManager.addTimer(duration: remainingInterval)
            activeTimers.insert(timerID)
            
            let viewModel = RaceItemViewModel(
                raceNumber: race.raceNumber,
                meetingName: race.meetingName,
                image: RaceCategory(rawValue: race.categoryId)?.displayIcon ?? Image(uiImage: .nextToGo),
                countryName: race.venueCountry,
                timerID: timerID
            )
            
            // Subscribe to the timer updates and update the ViewModel's countdown
            timerManager.$timers
                .receive(on: DispatchQueue.main)
                .compactMap { $0[timerID] }
                .sink { [weak viewModel] timer in
                    let remainingSeconds = max(0, Int(timer.remainingTime))
                    viewModel?.setCountdown(remainingSeconds)
                }
                .store(in: &cancellables)
            
            return viewModel
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
