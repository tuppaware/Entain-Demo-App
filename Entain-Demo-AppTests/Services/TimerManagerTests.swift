//
//  TimerManagerTests.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 10/11/2024.
//
import XCTest
import Combine
@testable import EntainDemoApp

final class TimerManagerTests: XCTestCase {
    private var timerManager: TimerManager!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        timerManager = TimerManager.shared
    }

    override func tearDown() {
        timerManager = nil
        cancellables = []
        super.tearDown()
    }

    func testAddTimer() {
        // Given: A duration for the timer
        let duration: TimeInterval = 5.0
        
        // When: Adding a timer with the specified duration
        let timerID = timerManager.addTimer(duration: duration)
        
        // Then: The timer should be added with the correct remaining time
        XCTAssertNotNil(timerManager.timers[timerID])
        XCTAssertEqual(timerManager.timers[timerID]?.remainingTime, duration)
    }

    func testTimerCountdown() {
        // Given: A duration for the timer
        let duration: TimeInterval = 3.0
        let timerID = timerManager.addTimer(duration: duration)
        
        // When: Waiting for the timer to decrement
        let expectation = self.expectation(description: "Timer should decrement")

        timerManager.$timers
            .sink { timers in
                // Then: The remaining time should decrease
                if let timer = timers[timerID], timer.remainingTime <= duration - 1.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.5)
    }

    func testTimerExpiration() {
        // Given: A short duration timer
        let duration: TimeInterval = 1.0
        let timerID = timerManager.addTimer(duration: duration)

        // When: Waiting for the timer to expire
        let expectation = self.expectation(description: "Timer should be removed after expiration")
        
        timerManager.$timers
            .sink { timers in
                // Then: The timer should be removed from the dictionary
                if timers[timerID] == nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testStopTimer() {
        // Given: A timer with a specific duration
        let duration: TimeInterval = 3.0
        let timerID = timerManager.addTimer(duration: duration)
        
        // When: Stopping the timer
        timerManager.stopTimer(for: timerID)
        
        let expectation = self.expectation(description: "Timer should not decrement after stop")

        // Then: The timer's remaining time should remain the same after the stop
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let timer = self.timerManager.timers[timerID] {
                XCTAssertEqual(timer.remainingTime, duration)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testRemoveTimer() {
        // Given: A timer added to the manager
        let timerID = timerManager.addTimer(duration: 3.0)
        
        // When: Removing the timer
        timerManager.removeTimer(for: timerID)
        
        // Then: The timer should be removed from the dictionary
        XCTAssertNil(timerManager.timers[timerID])
    }

    func testResetTimer() {
        // Given: A timer with an initial duration
        let duration: TimeInterval = 3.0
        let timerID = timerManager.addTimer(duration: duration)
        
        // When: Resetting the timer to a new duration
        let newDuration: TimeInterval = 10.0
        timerManager.resetTimer(for: timerID, duration: newDuration)
        
        // Then: The timer's remaining time should be updated to the new duration
        XCTAssertEqual(timerManager.timers[timerID]?.remainingTime, newDuration)
    }
}

