//
//  NextToGoDisplayModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation
import SharedUI

/// The display model for the Next To Go view
struct NextToGoDisplayModel {
    // Filter options to change what races we're going to show
    enum FilterOption: String, CaseIterable {
        case all
        case greyhoundRacing
        case horseRacing
        case harnessRacing
    }
    
    var filter: FilterOption = .all
    var currentRaces: RaceData?
    
    var allFilterDisplayModel: ButtonFilterDisplayModel {
        let buttons: [ButtonFilterDisplayModel.ButtonModel] = FilterOption.allCases.map(\.rawValue).map({ item in
            return ButtonFilterDisplayModel.ButtonModel(
                title: item,
                isSelected: false,
                image: nil
            )
        })
        return ButtonFilterDisplayModel(buttons: buttons)
    }
}
