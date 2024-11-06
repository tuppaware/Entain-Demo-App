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
    enum FilterOption: String, CaseIterable {
        case all, greyhoundRacing, horseRacing, harnessRacing
        
        var categoryID: String? {
            switch self {
            case .all: return nil
            case .greyhoundRacing: return RaceCategory.greyhoundRacing.rawValue
            case .horseRacing: return RaceCategory.horseRacing.rawValue
            case .harnessRacing: return RaceCategory.harnessRacing.rawValue
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
    }
    // Filter option, default to all
    @Published var filter: FilterOption = .all
    // Store of all the current races
    @Published var currentRaces: RaceData?
    // Central Time manager for Timers
    private let timerManager: CentralTimerManager
    // Gotta store those cancellables somewhere
    private var cancellables: Set<AnyCancellable> = []
    // Track active timers by their UUID
    private var activeTimers: [UUID] = []
    
    init(timerManager: CentralTimerManager) {
        self.timerManager = timerManager
    }
    
    var allFilterDisplayModel: ButtonFilterDisplayModel {
        let buttons = FilterOption.allCases.map { option in
            ButtonFilterDisplayModel.ButtonModel(
                title: option.displayTitle,
                isSelected: option == filter,
                image: nil
            )
        }
        return ButtonFilterDisplayModel(buttons: buttons)
    }
    
    var filteredRacesListDisplayModel: [RaceItemViewModel] {
        guard let races = currentRaces?.data?.raceSummaries.values else { return [] }
        
        let filteredRaces = races.filter { race in
            // Filter out races that are in the past
            if race.advertisedStart.seconds.isInPast {
                return false
            }
            
            // Filter by category
            if let categoryID = filter.categoryID {
                return race.categoryId == categoryID
            }
            
            return true
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
                venueName: race.venueName,
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

        return sortedRaceItemViewModels
    }
}
