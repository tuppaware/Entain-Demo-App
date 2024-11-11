//
//  MockURLProtocol.swift
//  NetworkingManager
//
//  Created by Adam Ware on 10/11/2024.
//
import Foundation

class MockURLProtocol: URLProtocol {
    // Define static variables to hold mock data and responses
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    // Required by URLProtocol, indicates whether to handle a request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // Required by URLProtocol, returns the canonical version of a request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // Start loading the mock data or error
    override func startLoading() {
        if let error = mockError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let mockResponse = mockResponse {
                self.client?.urlProtocol(self, didReceive: mockResponse, cacheStoragePolicy: .notAllowed)
            }
            if let mockData = mockData {
                self.client?.urlProtocol(self, didLoad: mockData)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        // This can be left empty for our mock
    }
}
