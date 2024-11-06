//
//  RaceItemViewModel.swift
//  SharedUI
//
//  Created by Adam Ware on 6/11/2024.
//

import Foundation
import SwiftUI

public protocol RaceItemViewModelProtocol {
    var raceNumber: Int { get }
    var meetingName: String { get }
    var image: Image { get }
    var timerID: UUID { get }
    func setLoading(_ isLoading: Bool)
    func updateRemainingTime(from interval: TimeInterval)
}


public final class RaceItemViewModel: RaceItemViewModelProtocol, ObservableObject {
    // MARK: - Properties
    @Published private(set) public var raceNumber: Int
    @Published private(set) public var meetingName: String
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var countDownTime: Int?
    @Published private(set) public var image: Image
    @Published private(set) var venueName: String
    
    public let uuid: UUID = .init()
    private(set) var remainingTime: String = ""
    private(set) public var timerID: UUID
    
    var countdownString: String {
        guard let countDownTime else { return "" }
            
        let hours = countDownTime / 3600
        let minutes = (countDownTime % 3600) / 60
        let seconds = countDownTime % 60
        
        var components: [String] = []
        
        if hours > 0 {
            components.append("\(hours)h")
        }
        // Show only minutes if time is over 5 minutes
        if countDownTime > 300 { // 300 seconds = 5 minutes
            components.append("\(minutes)m")
        } else {
            // Show both minutes and seconds if under 5 minutes
            if minutes > 0 {
                components.append("\(minutes)m")
            }
            components.append("\(seconds)s")
        }
        
        return components.joined(separator: " ")
    }

    public init(
        raceNumber: Int,
        meetingName: String,
        image: Image,
        venueName: String,
        timerID: UUID
    ) {
        self.raceNumber = raceNumber
        self.meetingName = meetingName
        self.image = image
        self.venueName = venueName
        self.timerID = timerID
    }

    public func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    public func setCountdown(_ countdown: Int) {
        self.countDownTime = countdown
    }
    
    public func updateRemainingTime(from interval: TimeInterval) {
        // Convert interval to a readable format, e.g., "HH:mm:ss"
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        self.remainingTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
