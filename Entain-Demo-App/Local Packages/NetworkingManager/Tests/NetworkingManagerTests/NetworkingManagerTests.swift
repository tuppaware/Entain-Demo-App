//
//  NetworkingManagerTests.swift
//  NetworkingManager
//
//  Created by Adam Ware on 10/11/2024.
//

import XCTest
@testable import NetworkingManager

final class NetworkingManagerTests: XCTestCase {
    
    var sut: NetworkingManager!
    var session: URLSession!
    var mockURLProtocol: MockURLProtocol!
    
    override func setUp() {
        super.setUp()
        
        // Configure URLSession with MockURLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        mockURLProtocol = MockURLProtocol()
        sut = NetworkingManager(session: session)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        
        mockURLProtocol.mockData = nil
        mockURLProtocol.mockResponse = nil
        mockURLProtocol.mockError = nil
        
        super.tearDown()
    }
    
    func testPerformRequestSuccess() async throws {
        // Given
        let endpoint = APIEndpoint.nextToGo(5)
        let expectedResponse = ["raceName": "Test Race"]
        let responseData = try! JSONSerialization.data(withJSONObject: expectedResponse)
        
        mockURLProtocol.mockData = responseData
        mockURLProtocol.mockResponse = HTTPURLResponse(url: endpoint.urlRequest.url!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        // When
        let result: [String: String] = try await sut.performRequest(endpoint: endpoint, type: [String: String].self)
        
        // Then
        XCTAssertEqual(result["raceName"], "Test Race")
    }
    
    func testPerformRequestClientError() async {
        // Given
        let endpoint = APIEndpoint.nextToGo(5)
        
        mockURLProtocol.mockResponse = HTTPURLResponse(url: endpoint.urlRequest.url!,
                                                       statusCode: 404,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        // When/Then
        do {
            let _: [String: String] = try await sut.performRequest(endpoint: endpoint, type: [String: String].self)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as NetworkingErrors {
            XCTAssertEqual(error, .serverError(statusCode: 404))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testPerformRequestServerError() async {
        // Given
        let endpoint = APIEndpoint.nextToGo(5)
        
        mockURLProtocol.mockResponse = HTTPURLResponse(url: endpoint.urlRequest.url!,
                                                       statusCode: 500,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        // When/Then
        do {
            let _: [String: String] = try await sut.performRequest(endpoint: endpoint, type: [String: String].self)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as NetworkingErrors {
            XCTAssertEqual(error, .serverError(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testPerformRequestDecodingError() async {
        // Given
        let endpoint = APIEndpoint.nextToGo(5)
        let invalidData = "Invalid JSON".data(using: .utf8)!
        
        mockURLProtocol.mockData = invalidData
        mockURLProtocol.mockResponse = HTTPURLResponse(url: endpoint.urlRequest.url!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        // When/Then
        do {
            let _: [String: String] = try await sut.performRequest(endpoint: endpoint, type: [String: String].self)
            XCTFail("Expected to throw an error but didn't")
        } catch let error as NetworkingErrors {
            XCTAssertEqual(error, .invalidDecoding)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
