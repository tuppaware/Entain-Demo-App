//
//  NetworkManager.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//
import Foundation
import Combine

/// Protocol for the NetworkManager using async/await.
public protocol NetworkServiceProtocol {
    /// Performs a network request based on the given APIEndpoint and decodes the response into the specified Decodable type.
    /// - Parameters:
    ///   - endpoint: An object conforming to `APIEndpoint` protocol.
    ///   - type: The expected `Decodable` type of the response.
    /// - Returns: The decoded object or throws an error.
    func performRequest<T: Decodable>(endpoint: APIEndpoint, type: T.Type) async throws -> T
}

import Foundation

/// A class responsible for handling network requests using async/await.
public class NetworkingManager: NetworkServiceProtocol {
    private let session: URLSession
    
    /// Initializes a new instance of NetworkingManager.
    /// - Parameter session: The URLSession instance to use for network requests.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs a network request based on the given APIEndpoint and decodes the response into the specified Decodable type.
    /// - Parameters:
    ///   - endpoint: An object conforming to `APIEndpoint` protocol.
    ///   - type: The expected `Decodable` type of the response.
    /// - Returns: The decoded object or throws an error.
    public func performRequest<T: Decodable>(
        endpoint: APIEndpoint,
        type: T.Type
    ) async throws -> T {
        let request = endpoint.urlRequest
        
        do {
            // Perform the network request using async/await
            let (data, response) = try await session.data(for: request)
            
            // Validate the HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingErrors.invalidHTTPResponse
            }
            
            // Handle different HTTP status codes
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    // Decode the JSON data into the specified type
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                } catch {
                    // Throw decoding error
                    throw NetworkingErrors.invalidDecoding
                }
            case 400...499:
                // Handle client errors
                throw NetworkingErrors.serverError(statusCode: httpResponse.statusCode)
            case 500...599:
                // Handle server errors
                throw NetworkingErrors.serverError(statusCode: httpResponse.statusCode)
            default:
                // Unknown errors
                throw NetworkingErrors.unknown
            }
        } catch {
            // Re-throw any networking errors
            throw error
        }
    }
}

