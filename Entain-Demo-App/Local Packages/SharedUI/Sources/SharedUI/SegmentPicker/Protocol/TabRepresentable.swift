//
//  TabRepresentable.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import Foundation
import SwiftUI

// Define a protocol that represents a tab in the UI, providing essential properties for display and categorization.
public protocol TabRepresentable: Identifiable, Equatable {
    /// The title displayed for the tab in the UI.
    var displayTitle: String { get }
    
    /// The icon associated with the tab, if available.
    var displayIcon: Image? { get }
    
    /// A unique category identifier for the tab, used for categorization or filtering.
    var categoryID: String { get }
}

// Model representing a tab, conforming to TabRepresentable to ensure it includes the required properties and behaviors.
public struct TabModel: TabRepresentable {
    /// Unique identifier for the tab instance.
    public let id: UUID = UUID()
    
    /// The title displayed for the tab in the UI.
    public let displayTitle: String
    
    /// The icon associated with the tab, if available.
    public let displayIcon: Image?
    
    /// A unique category identifier for the tab, used for categorization or filtering.
    public let categoryID: String

    /// Initializes a new instance of `TabModel`.
    /// - Parameters:
    ///   - displayTitle: The title to be displayed for the tab.
    ///   - displayIcon: An optional icon image for the tab.
    ///   - categoryID: The unique category identifier for the tab.
    public init(
        displayTitle: String,
        displayIcon: Image?,
        categoryID: String
    ) {
        self.displayTitle = displayTitle
        self.displayIcon = displayIcon
        self.categoryID = categoryID
    }

    /// Checks equality between two `TabModel` instances by comparing their unique identifiers.
    public static func == (lhs: TabModel, rhs: TabModel) -> Bool {
        lhs.id == rhs.id
    }
}

