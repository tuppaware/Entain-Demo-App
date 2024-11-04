//
//  EndpointRequest.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//

import Foundation

/// Protocol defining the requirements for generating a URLRequest for API calls
public protocol EndpointRequest {
    /// The base URL of the API endpoint
    var baseURL: URL { get }
    /// The path appended to the base URL to form the full URL
    var path: String { get }
    /// The HTTP method used for the request (e.g., GET, POST)
    var method: HTTPMethods { get }
    /// Optional HTTP headers to include in the request
    var headers: [String: String]? { get }
    /// Optional HTTP body data for the request
    var body: Data? { get }
}

extension EndpointRequest {
    /// Computed property that constructs a URLRequest from the endpoint information
    public var urlRequest: URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
