//
//  NetworkingErrors.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//
import Foundation

/// Standard type to describe HTTP errors
public enum NetworkingErrors: Error, Equatable {
    case invalidURL
    case invalidHTTPResponse
    case invalidDecoding
    case serverError(statusCode: Int)
    case unknown
}
