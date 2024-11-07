//
//  InfoStateProtocol.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//
import Foundation
import SwiftUI

// Define the protocol with required properties
public protocol InfoStateProtocol {
    var image: Image { get }
    var title: String { get }
    var description: String { get }
    var primaryCTAColor: Color { get }
    var primaryCTATitle: String { get }
    var primaryCTA: () -> Void { get }
}
