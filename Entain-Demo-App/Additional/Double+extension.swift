//
//  Double+extension.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 6/11/2024.
//

import Foundation

extension Double {
    /// Checks if the Unix timestamp is in the past.
    var isInPast: Bool {
        let currentTimestamp = Date().timeIntervalSince1970
        return self < currentTimestamp
    }
    
    /// Checks if the Unix timestamp is in the future./
    var isInFuture: Bool {
        let currentTimestamp = Date().timeIntervalSince1970
        return self > currentTimestamp
    }
}
