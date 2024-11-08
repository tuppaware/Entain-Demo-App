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

/// The display model for the Next To Go view. required as a Class to handle the timers.
final class NextToGoDisplayModel: ObservableObject {
    
    /// Filtering options used in the Segment Control.
    /// Presents the 4 options with computed properties to return the correct information.
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
    // Filtered races list
    @Published var filteredRacesListDisplayModel: [RaceItemViewModel] = []
    // Central Timer Manager for Timers
    private let timerManager: CentralTimerManager
    // Store cancellables for Combine subscriptions
    private var cancellables: Set<AnyCancellable> = []
    // Track active timers by their UUID
    private var activeTimers: Set<UUID> = []
    
    init(timerManager: CentralTimerManager) {
        self.timerManager = timerManager
    }
    
    // Returns all filter options for the Segment Display
    var allFilterDisplayModel: CustomSegmentedDisplayModel<FilterOption> {
        CustomSegmentedDisplayModel(tabs: FilterOption.allCases)
    }
    
    func filterRaces(_ filterOption: FilterOption) {
        guard let races = currentRaces?.data?.raceSummaries.values else { return }
        
        // **Clear Existing Timers and Subscriptions**
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        for timerID in activeTimers {
            timerManager.removeTimer(for: timerID)
        }
        activeTimers.removeAll()
        
        // Step 1: Filter races based on the selected filter
        var filteredRaces = races.filter { race in
            // Exclude races that are in the past
            if race.advertisedStart.seconds.isInPast {
                return false
            }
            
            // Include races that match the selected category
            return (filterOption == .all) ? true : (race.categoryId == filterOption.categoryID)
        }
        .sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
        
        // Step 2: If fewer than 5 races, fetch additional races from other categories
        if filteredRaces.count < 5 {
            let missingCount = 5 - filteredRaces.count
            
            // Fetch additional races not in the filtered list and not in the past
            let additionalRaces = races.filter { race in
                // Exclude races already included
                !filteredRaces.contains(where: { $0.raceId == race.raceId }) &&
                // Exclude races in the past
                !race.advertisedStart.seconds.isInPast
            }
            .sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
            .prefix(missingCount)
            
            // Append the additional races to the filtered races
            filteredRaces.append(contentsOf: additionalRaces)
        }
        
        // Step 3: Limit to 5 races
        filteredRaces = Array(filteredRaces.prefix(5))
        
        // Step 4: Create timers for countdowns to start of races
        // Output them as a Race Item View Model
        let raceItemViewModels = filteredRaces.map { race -> RaceItemViewModel in
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
            
            timerManager.$timers
                .receive(on: DispatchQueue.main)
                .compactMap { $0[timerID] }
                .sink { timer in
                    let remainingSeconds = max(0, Int(timer.remainingTime))
                    viewModel.setCountdown(remainingSeconds)
                }
                .store(in: &cancellables)
            
            return viewModel
        }
        // return filteres races 
        self.filteredRacesListDisplayModel = raceItemViewModels
    }
}
