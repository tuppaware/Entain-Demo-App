//
//  RaceCategory.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 8/11/2024.
//
import Foundation
import SwiftUI

/// Race Category enum for filtering and returning correct image within the list
enum RaceCategory: String, Codable, CaseIterable {
    case greyhoundRacing = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case horseRacing = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case harnessRacing = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case all = ""
    
    // Return the correct image for the selected Race Category
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
