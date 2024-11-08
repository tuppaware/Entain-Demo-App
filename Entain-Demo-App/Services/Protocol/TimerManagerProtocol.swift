//
//  TimerManagerProtocol.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 8/11/2024.
//
import Foundation
import Combine

/// A protocol for managing multiple timers centrally and publishing updates.
protocol TimerManagerProtocol: AnyObject, ObservableObject {
    /// A dictionary of timer items managed by their UUID.
    var timers: [UUID: TimerItem] { get }
    
    /// Adds a new timer item to the manager with a specified duration.
    /// - Parameter duration: The duration of the timer in seconds.
    /// - Returns: The unique identifier (UUID) of the created timer.
    func addTimer(duration: TimeInterval) -> UUID
    
    /// Stops a timer for a given timer item ID.
    /// - Parameter id: The unique identifier (UUID) of the timer to stop.
    func stopTimer(for id: UUID)
    
    /// Removes a timer item completely.
    /// - Parameter id: The unique identifier (UUID) of the timer to remove.
    func removeTimer(for id: UUID)
    
    /// Resets a timer to a new duration.
    /// - Parameters:
    ///   - id: The unique identifier (UUID) of the timer to reset.
    ///   - duration: The new duration of the timer in seconds.
    func resetTimer(for id: UUID, duration: TimeInterval)
}
