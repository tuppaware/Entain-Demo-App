//
//  CustomSegmentedDisplayModel.swift
//  SharedUI
//
//  Created by Adam Ware on 5/11/2024.
//
import Foundation
import SwiftUI

// Make the CustomSegmentedDisplayModel generic over any TabRepresentable
public struct CustomSegmentedDisplayModel<Tab: TabRepresentable> {
    public let tabs: [Tab]

    public init(tabs: [Tab]) {
        self.tabs = tabs
    }
}

