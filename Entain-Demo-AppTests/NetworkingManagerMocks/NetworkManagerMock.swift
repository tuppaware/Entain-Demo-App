//
//  NetworkManagerMock.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 11/11/2024.
//
import Foundation
import Combine
@testable import NetworkingManager
@testable import EntainDemoApp

/// A mock implementation of `NetworkServiceProtocol` for testing purposes.
public class NetworkManagerMock: NetworkServiceProtocol {
    /// A dictionary mapping API endpoints to their corresponding mock results (success or failure).
    private let responses: [APIEndpoint: Result<Data, Error>]

    /// Initializes the mock network manager with predefined responses.
    /// - Parameter responses: A dictionary of `APIEndpoint` keys to `Result<Data, Error>` values.
    public init(responses: [APIEndpoint: Result<Data, Error>] = [:]) {
        self.responses = responses
    }

    /// Performs a mock network request based on the given APIEndpoint and decodes the response into the specified Decodable type.
    /// - Parameters:
    ///   - endpoint: An object conforming to `APIEndpoint` protocol.
    ///   - type: The expected `Decodable` type of the response.
    /// - Returns: The decoded object or throws an error.
    public func performRequest<T: Decodable>(
        endpoint: APIEndpoint,
        type: T.Type
    ) async throws -> T {
        // Check if a predefined response exists for the given endpoint
        if let result = responses[endpoint] {
            switch result {
            case .success(let data):
                do {
                    // Decode the JSON data into the specified type
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                } catch {
                    // Throw decoding error
                    throw NetworkingErrors.invalidDecoding
                }
            case .failure(let error):
                // Throw the predefined error
                throw error
            }
        } else {
            // Throw an error if no response is set for the endpoint
            throw NetworkingErrors.unknown
        }
    }
}
