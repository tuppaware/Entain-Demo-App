//
//  TimerManager.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 6/11/2024.
//

import Foundation
import Combine

/// A struct representing a timer item with a unique ID and a remaining time.
struct TimerItem {
    let id: UUID
    var remainingTime: TimeInterval
}

/// A class to manage multiple timers centrally and publish updates.
class CentralTimerManager: ObservableObject {
    /// A dictionary of timer items managed by their UUID.
    @Published private(set) var timers: [UUID: TimerItem] = [:]
    
    private var timerCancellables: [UUID: AnyCancellable] = [:]
    private let timerInterval: TimeInterval = 1.0 // Set the update frequency, 0.5 seconds otherwise the value often falls between 0...1
    private let timerQueue = DispatchQueue(label: "centralTimerQueue")
    
    /// Singleton instance for centralized access.
    static let shared = CentralTimerManager()
    
    private init() {}
    
    /// Adds a new timer item to the manager.
    func addTimer(duration: TimeInterval) -> UUID {
        let id = UUID()
        let newTimerItem = TimerItem(id: id, remainingTime: duration)
        timers[id] = newTimerItem
        
        // Schedule the timer updates
        startTimer(for: id)
        
        return id
    }
    
    /// Starts a timer for a given timer item ID.
    private func startTimer(for id: UUID) {
        timerCancellables[id] = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .receive(on: timerQueue)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateTimer(id: id)
            }
    }
    
    /// Updates a timer by decreasing its remaining time.
    private func updateTimer(id: UUID) {
        guard let currentTimer = timers[id] else { return }
        
        var updatedTimer = currentTimer
        updatedTimer.remainingTime -= timerInterval
        
        // Check if the timer has expired
        if updatedTimer.remainingTime <= 0 {
            // Stop the timer and remove it
            stopTimer(for: id)
            timers.removeValue(forKey: id)
        } else {
            // Update the timer's remaining time
            DispatchQueue.main.async {
                self.timers[id] = updatedTimer
            }
        }
    }
    
    /// Stops a timer for a given timer item ID.
    func stopTimer(for id: UUID) {
        timerCancellables[id]?.cancel()
        timerCancellables.removeValue(forKey: id)
    }
    
    /// Removes a timer item completely.
    func removeTimer(for id: UUID) {
        stopTimer(for: id)
        timers.removeValue(forKey: id)
    }
    
    /// Resets a timer to a new duration.
    func resetTimer(for id: UUID, duration: TimeInterval) {
        guard timers[id] != nil else { return }
        timers[id]?.remainingTime = duration
    }
}
