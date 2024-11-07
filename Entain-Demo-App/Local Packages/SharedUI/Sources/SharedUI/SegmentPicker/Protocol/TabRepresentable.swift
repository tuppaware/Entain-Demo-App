//
//  TabRepresentable.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import Foundation
import SwiftUI

// Define a protocol that represents a tab
public protocol TabRepresentable: Identifiable, Equatable {
    var displayTitle: String { get }
    var displayIcon: Image { get }
    var categoryID: String { get }
}

// Make TabModel conform to the protocol
public struct TabModel: TabRepresentable {
    public let id: UUID = UUID()
    public let displayTitle: String
    public let displayIcon: Image
    public let categoryID: String

    public init(
        displayTitle: String,
        displayIcon: Image,
        categoryID: String
    ) {
        self.displayTitle = displayTitle
        self.displayIcon = displayIcon
        self.categoryID = categoryID
    }

    public static func == (lhs: TabModel, rhs: TabModel) -> Bool {
        lhs.id == rhs.id
    }
}
