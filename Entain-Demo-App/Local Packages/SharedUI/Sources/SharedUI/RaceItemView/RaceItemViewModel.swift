//
//  RaceItemViewModel.swift
//  SharedUI
//
//  Created by Adam Ware on 6/11/2024.
//

import Foundation
import SwiftUI
import FlagKit

/// ViewModel representing a single race item, with countdown timer and related UI data
public final class RaceItemViewModel: RaceItemViewModelProtocol, ObservableObject {
    
    // MARK: - Properties
    
    /// Race number displayed on the UI
    @Published private(set) public var raceNumber: Int
    
    /// Name of the meeting associated with the race
    @Published private(set) public var meetingName: String
    
    /// Image representing the race type or category
    @Published private(set) public var image: Image
    
    /// Name of the country where the race is held
    @Published private(set) public var countryName: String
    
    /// Flag to indicate whether the race item is loading
    @Published private var isLoading: Bool = false
    
    /// Time remaining until race start, in seconds
    @Published private(set) public var countDownTime: Int?
    
    /// Unique identifier for managing countdown timers
    private(set) public var timerID: UUID
    
    /// A UUID for uniquely identifying each instance of `RaceItemViewModel`
    public let uuid: UUID = .init()
    
    // MARK: - Computed Properties
    
    /// Converts the countdown time into a readable string format
    /// - Returns: A string representation of the countdown (e.g., "5m 30s")
    var countdownString: String {
        guard let countDownTime else { return "" }
            
        let hours = countDownTime / 3600
        let minutes = (countDownTime % 3600) / 60
        let seconds = countDownTime % 60
        
        var components: [String] = []
        
        switch true {
        case countDownTime < 1:
            return ""
        case hours > 0:
            components.append("\(hours)h")
        case countDownTime > 300:
            components.append("\(minutes)m")
        case countDownTime < 300 && minutes > 0:
            components.append("\(minutes)m")
            components.append("\(seconds)s")
        case countDownTime < 300 && minutes < 1:
            components.append("\(seconds)s")
        default :
            return ""
        }

        return components.joined(separator: " ")
    }
    
    /// Retrieves an optional flag image based on the country code.
    /// This is best effort, as truncating 3 code to 2 sometimes doesnt return the right flag
    /// - Returns: An optional `Image` displaying the country's flag
    public var flagCountryCode: Image? {
        if let imageAsset = Flag(countryCode: String(countryName.prefix(2)))?.originalImage {
            return Image(uiImage: imageAsset)
        } else {
            return nil
        }
    }

    // MARK: - Initializer
    
    /// Initializes a new instance of `RaceItemViewModel`.
    /// - Parameters:
    ///   - raceNumber: The number of the race
    ///   - meetingName: The name of the meeting location
    ///   - image: The image representing the race type
    ///   - countryName: The name of the country hosting the race
    ///   - timerID: Unique ID for the countdown timer
    public init(
        raceNumber: Int,
        meetingName: String,
        image: Image,
        countryName: String,
        timerID: UUID
    ) {
        self.raceNumber = raceNumber
        self.meetingName = meetingName
        self.image = image
        self.countryName = countryName
        self.timerID = timerID
    }

    // MARK: - Methods
    
    /// Sets the loading state of the view model.
    /// - Parameter isLoading: Boolean indicating if the view model is loading
    public func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    /// Updates the countdown timer with the remaining time.
    /// - Parameter countdown: The countdown time in seconds
    public func setCountdown(_ countdown: Int) {
        self.countDownTime = countdown
    }
}
