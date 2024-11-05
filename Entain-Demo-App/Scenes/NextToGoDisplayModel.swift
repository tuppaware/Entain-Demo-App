//
//  NextToGoDisplayModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation

/// The display model for the Next To Go view
struct NextToGoDisplayModel {
    // Filter options to change what races we're going to show
    enum FilterOption: String, CaseIterable {
        case all
        case grayhoundRacing
        case horseRacing
        case harnessRacing
    }
    
    var filter: FilterOption = .all
    var currentRaces: RaceData?
}
