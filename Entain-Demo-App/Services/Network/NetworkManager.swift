//
//  NetworkManager.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//
import Foundation
import Combine

/// Protocol for the NetworkManager
protocol NetworkServiceProtocol {
    func performRequest<T: Decodable>(endpoint: EndpointRequest, type: T.Type) -> AnyPublisher<T, Error>
}

/// A class responsible for handling network requests.
public class NetworkManager: NetworkServiceProtocol {
    private let session: URLSession
    
    /// Initializes a new instance of NetworkManager.
    /// - Parameter session: The URLSession instance to use for network requests.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs a network request based on the given EndpointRequest and decodes the response into the specified Decodable type.
    /// - Parameters:
    ///   - endpoint: An object conforming to EndpointRequest protocol.
    ///   - type: The expected Decodable type of the response.
    /// - Returns: A publisher that emits the decoded object or an error.
    public func performRequest<T: Decodable>(
        endpoint: EndpointRequest,
        type: T.Type
    ) -> AnyPublisher<T, Error> {
        let request = endpoint.urlRequest
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkingErrors.invalidHTTPResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    do {
                        let data = try JSONDecoder().decode(T.self, from: output.data)
                        return data
                    } catch {
                        // Throw decoding error
                        throw NetworkingErrors.invalidDecoding
                    }
                case 400...499:
                    // Handle client errors
                    throw NetworkingErrors.serverError(
                        statusCode: httpResponse.statusCode
                    )
                case 500...599:
                    // Handle server errors
                    throw NetworkingErrors.serverError(
                        statusCode: httpResponse.statusCode
                    )
                default:
                    // Unknown errors
                    throw NetworkingErrors.unknown
                }
            }
            // Likely to result in UI change, so receieve on main thread.
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
