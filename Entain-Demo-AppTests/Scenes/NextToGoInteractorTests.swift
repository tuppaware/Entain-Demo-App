//
//  NextToGoInteractorTests.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 10/11/2024.
//
import XCTest
import Combine
import NetworkingManager
@testable import EntainDemoApp

@MainActor
final class NextToGoInteractorTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var interactor: NextToGoInteractor!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        interactor = nil
        super.tearDown()
    }
    
    func testFetchNextToGoSuccess() async throws {
        // Arrange
        let mockRaceData = MockData.raceDataJSON
        let mockData = try JSONEncoder().encode(mockRaceData)
        let networkMock = NetworkManagerMock(responses: [.nextToGo(20): .success(mockData)])
        let transformedData = returnRaceData()

        interactor = NextToGoInteractor(networkService: networkMock)
        
        // Expectation
        let expectation = XCTestExpectation(description: "Should receive race data")

        interactor.nextToGoRacesPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { data in
                XCTAssertEqual(data?.data?.nextToGoIds, transformedData.data?.nextToGoIds)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        interactor.nextToGoRaces = returnRaceData()
        
        // Wait for expectations
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testFetchNextToGoFailure() async throws {
        // Arrange
        let networkMock = NetworkManagerMock(responses: [.nextToGo(20): .failure(NetworkingErrors.serverError(statusCode: 500))])
        
        interactor = NextToGoInteractor(networkService: networkMock)
        
        let expectation = XCTestExpectation(description: "Should receive an error")
        
        // Act
        interactor.errorPublisher
            .sink { error in
                XCTAssertEqual(error, NetworkingErrors.serverError(statusCode: 500))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger data fetch
        interactor.refreshData()
        
        // Wait for expectations
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    private func returnRaceData() -> RaceData {
        // Decode JSON into RaceData for testing
        let mockRaceData = MockData.raceDataJSON
        let raceData: RaceData = {
            do {
                return try JSONDecoder().decode(RaceData.self, from: mockRaceData)
            } catch {
                fatalError("Failed to decode RaceData from JSON: \(error)")
            }
        }()
        return raceData
    }
}
