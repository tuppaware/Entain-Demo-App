//
//  RaceItemViewModelProtocol.swift
//  SharedUI
//
//  Created by Adam Ware on 8/11/2024.
//
import Foundation
import SwiftUI

/// Protocol defining the requirements for a Race Item View Model
public protocol RaceItemViewModelProtocol {
    var raceNumber: Int { get }
    var meetingName: String { get }
    var image: Image { get }
    var countryName: String { get }
    var timerID: UUID { get }
    
    /// Sets the loading state for the race item
    /// - Parameter isLoading: A boolean indicating if the item is loading
    func setLoading(_ isLoading: Bool)
    
    /// Updates the countdown timer with the remaining time.
    /// - Parameter countdown: The countdown time in seconds
    func setCountdown(_ countdown: Int)
}
