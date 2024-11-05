//
//  APIEndpoint.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import Foundation

/// Enum representing various API endpoints with associated request details
public enum APIEndpoint: EndpointRequest {
    // return our next to go races - passing the number of races we want returned from the endpoint.
    case nextToGo(Int)

    // Base URL for the API
    public var baseURL: URL {
        let baseURL = Configuration.value(for: .baseURL)
        guard let url = URL(string: "https://\(baseURL ?? "")") else {
            // TODO: Handle this error more graccefully with logging
            return URL(string: "https://entain.com")!
        }
        return url
    }

    // Computed path for each endpoint case
    // passes the count of races we want returned
    public var path: String {
        switch self {
        case .nextToGo(let count):
            return "rest/v1/racing/"
        }
    }
    
    public var queryParameters: [String : String]? {
        switch self {
        case .nextToGo(let count):
            return [
                "method": "nextraces",
                "count": "\(count)"
            ]
        }
    }

    // HTTP method for each endpoint case
    public var method: HTTPMethods {
        switch self {
        case .nextToGo(_):
            return .get
        }
    }

    // Optional headers for each endpoint case
    public var headers: [String: String]? {
        switch self {
        case .nextToGo(_):
            return nil
        }
    }

    // Optional body for each endpoint case
    public var body: Data? {
        switch self {
        default:
            return nil
        }
    }
}
