//
//  NextToGoDisplayModelTests.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 10/11/2024.
//
import XCTest
import Combine
@testable import EntainDemoApp

final class NextToGoDisplayModelTests: XCTestCase {
    
    var sut: NextToGoDisplayModel!
    var timerManager: TimerManager!
    var cancellables: Set<AnyCancellable>!
    let mockData = MockData.raceDataJSON

    override func setUp() {
        super.setUp()
        timerManager = TimerManager.shared
        sut = NextToGoDisplayModel()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        timerManager = nil
        super.tearDown()
    }

    func testFilterRaces_AllOption_ShouldDisplayAllRaces() {
        // Reset timer
        timerManager.clearAllTimers()
        
        // Given: Set up mock race data
        let mockRaces = returnRaceData()
        sut.currentRaces = mockRaces


        // When: Apply 'All' filter
        let expectation = self.expectation(description: "Filtering all races")
        sut.$filteredRacesListDisplayModel
            .dropFirst()
            .sink { races in
                // Then: Verify all races are displayed
                XCTAssertEqual(races.count, mockRaces.data!.raceSummaries.count, "All races should be displayed when 'All' filter is selected")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.filterRaces(.all)
        
        waitForExpectations(timeout: 1)
    }

    func testFilterRaces_HorseOption_ShouldDisplayOnlyHorseRaces() {
        // Reset timer
        timerManager.clearAllTimers()
        // Given: Set up mock data with fewer races than the minimum required
        let mockRaces = returnRaceData()
        sut.currentRaces = mockRaces
        
        // When: Apply 'Horse' filter with insufficient initial races
        let expectation = self.expectation(description: "Ensuring minimum race count when filteres")
        sut.$filteredRacesListDisplayModel
            .dropFirst()
            .sink { races in
                // Then: Verify at least the minimum number of races is displayed
                XCTAssertGreaterThanOrEqual(races.count, 5, "At least 5 races should be displayed")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.filterRaces(.horseRacing)
        
        waitForExpectations(timeout: 1)
    }

    func testEnsureMinimumRaceCount_WhenLessThanMinimum_ShouldAddMoreRaces() {
        // Reset timer
        timerManager.clearAllTimers()
        // Given: Set up mock data with fewer races than the minimum required
        let mockRaces = returnRaceData()
        sut.currentRaces = mockRaces
        
        // When: Apply 'Horse' filter with insufficient initial races
        let expectation = self.expectation(description: "Ensuring minimum race count")
        sut.$filteredRacesListDisplayModel
            .dropFirst()
            .sink { races in
                // Then: Verify at least the minimum number of races is displayed
                XCTAssertGreaterThanOrEqual(races.count, 5, "At least 5 races should be displayed even when fewer races are initially filtered")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.filterRaces(.horseRacing)
        
        waitForExpectations(timeout: 1)
    }

    func testTimersAreSetUpForRaces() {
        // Reset timers
        timerManager.clearAllTimers()
        
        // Given: Set up mock race data
        let mockRaces = returnRaceData()
        sut.currentRaces = mockRaces
        
        // Expected number of timers
        let expectedTimerCount = mockRaces.data?.raceSummaries.count ?? 0
        XCTAssert(expectedTimerCount > 0, "There should be at least one race summary")
        
        // Create an expectation for timers to be set up
        let expectation = self.expectation(description: "Timers are set up for all races")
        
        // Subscribe to the timers publisher
        timerManager.$timers
            .receive(on: RunLoop.main)
            .sink { timers in
                if timers.count == expectedTimerCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When: Apply 'All' filter
        sut.filterRaces(.all)
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Timers were not set up in time: \(error)")
            }
        }
        
        // Then: Verify that timers are set up for each race
        XCTAssertEqual(timerManager.timers.count, expectedTimerCount, "Timers should be set up for each race")
    }
    
    private func returnRaceData() -> RaceData {
        // Decode JSON into RaceData for testing
        let raceData: RaceData = {
            do {
                return try JSONDecoder().decode(RaceData.self, from: mockData)
            } catch {
                fatalError("Failed to decode RaceData from JSON: \(error)")
            }
        }()
        return raceData
    }
}
