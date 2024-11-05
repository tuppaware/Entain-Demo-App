//
//  Config.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//

import Foundation

/// Configuration values sourced from the Config.xconfig file.
/// Normally sensitive keys/values would be populated from an .env file or done at the pipeline.
/// This would not be checked into the repo
enum Configuration: String {
    case baseURL = "BASE_URL"
    
    static func value(for key: Configuration) -> String? {
        let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
        return value
    }
}
