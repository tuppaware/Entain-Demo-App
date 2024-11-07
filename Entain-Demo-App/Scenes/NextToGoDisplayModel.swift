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

/// Race Category enum for filtering and returning correct image
enum RaceCategory: String, Codable, CaseIterable {
    case greyhoundRacing = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case horseRacing = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case harnessRacing = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case all = ""
    
    var displayIcon: Image {
        switch self {
        case .all:
            return Image(.nextToGo)
        case .greyhoundRacing:
            return Image(.greyhoundRacing)
        case .horseRacing:
            return Image(.horseRacing)
        case .harnessRacing:
            return Image(.harnessRacing)
        }
    }
}

/// The display model for the Next To Go view. required as a Class to handle the timers.
final class NextToGoDisplayModel: ObservableObject {
    enum FilterOption: String, CaseIterable, TabRepresentable {
        case all = "All"
        case greyhoundRacing = "Greyhound Racing"
        case horseRacing = "Horse Racing"
        case harnessRacing = "Harness Racing"
        
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
            switch self {
            case .all: return "All"
            case .greyhoundRacing: return "Greyhound Racing"
            case .horseRacing: return "Horse Racing"
            case .harnessRacing: return "Harness Racing"
            }
        }
        
        var displayIcon: Image {
            switch self {
            case .all:
                return Image(.nextToGo)
            case .greyhoundRacing:
                return Image(.greyhoundRacing)
            case .horseRacing:
                return Image(.horseRacing)
            case .harnessRacing:
                return Image(.harnessRacing)
            }
        }
    }
    
    // Store of all the current races
    @Published var currentRaces: RaceData?
    // Central Time manager for Timers
    private let timerManager: CentralTimerManager
    // Filtered races list
    @Published var filteredRacesListDisplayModel: [RaceItemViewModel] = []
    // Gotta store those cancellables somewhere
    private var cancellables: Set<AnyCancellable> = []
    // Track active timers by their UUID
    private var activeTimers: [UUID] = []
    
    init(timerManager: CentralTimerManager) {
        self.timerManager = timerManager
    }
    
    var allFilterDisplayModel: CustomSegmentedDisplayModel<FilterOption> {
        return CustomSegmentedDisplayModel(tabs: FilterOption.allCases)
    }
    
    // todo: clear timers - Also count up to 5 races always
    func filterRaces(_ filterOption: FilterOption) {
        guard let races = currentRaces?.data?.raceSummaries.values else { return }
        
        let filteredRaces = races.filter { race in
            // Filter out races that are in the past
            if race.advertisedStart.seconds.isInPast {
                return false
            }
            
            // Filter by category, return true if all
            return (filterOption == .all) ? true : (race.categoryId == filterOption.categoryID)
        }
        // Sort by Advertised Start time
        .sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
        .map { race in
            // Work out the time in the future the race will end
            let remainingInterval = race.advertisedStart.seconds - Date().timeIntervalSince1970
            
            // Create a timer for the race countdown
            let timerID = timerManager.addTimer(duration: remainingInterval)
            
            // generate display model for List View
            let viewModel = RaceItemViewModel(
                raceNumber: race.raceNumber,
                meetingName: race.meetingName,
                image: RaceCategory(rawValue: race.categoryId)?.displayIcon ?? Image(uiImage: .nextToGo),
                countryName: race.venueCountry,
                timerID: timerID
            )
            
            // Subscribe to timer updates
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
        
        // Filter out races whose timers have expired
        let activeRaceItemViewModels = filteredRaces.filter { viewModel in
            if let timer = timerManager.timers[viewModel.timerID] {
                return timer.remainingTime > 0
            } else {
                return false
            }
        }

        // Sort the active race item view models
        let sortedRaceItemViewModels = activeRaceItemViewModels.sorted { vm1, vm2 in
            let time1 = timerManager.timers[vm1.timerID]?.remainingTime ?? 0
            let time2 = timerManager.timers[vm2.timerID]?.remainingTime ?? 0
            return time1 < time2
        }

        self.filteredRacesListDisplayModel = sortedRaceItemViewModels
    }
}
