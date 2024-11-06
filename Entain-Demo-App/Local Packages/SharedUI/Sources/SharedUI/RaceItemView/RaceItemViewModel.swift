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
    var countryName: String { get }
    var timerID: UUID { get }
    func setLoading(_ isLoading: Bool)
}

public final class RaceItemViewModel: RaceItemViewModelProtocol, ObservableObject {
    // MARK: - Properties
    @Published private(set) public var raceNumber: Int
    @Published private(set) public var meetingName: String
    @Published private(set) public var image: Image
    @Published private(set) public var countryName: String
    @Published private var isLoading: Bool = false
    @Published private var countDownTime: Int?
    private(set) public var timerID: UUID
    public let uuid: UUID = .init()

    // Computed count down string
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

    public func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    public func setCountdown(_ countdown: Int) {
        self.countDownTime = countdown
    }
}
