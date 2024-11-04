//
//  HTTPMethods.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//

/// Define HTTP methods 
public enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    // We are unlikely to need these, but here for completionst reasons 
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
