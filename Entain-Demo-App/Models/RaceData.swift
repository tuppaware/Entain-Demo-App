//
//  RaceData.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//

import Foundation

/// Main structure for the Racing API endpoint.
/// Making an assumption that we should really shoudn't be relying on a backend not to break contract.
/// So we attempt to avoid unhandled exceptions with codeable by using .decodeIfPresent
struct RaceData: Codable {
    let status: Int?
    let data: DataClass?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        data = try container.decodeIfPresent(DataClass.self, forKey: .data)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    struct DataClass: Codable {
        let nextToGoIds: [String]?
        let raceSummaries: [String: RaceSummary]?

        enum CodingKeys: String, CodingKey {
            case nextToGoIds = "next_to_go_ids"
            case raceSummaries = "race_summaries"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            nextToGoIds = try container.decodeIfPresent([String].self, forKey: .nextToGoIds)
            raceSummaries = try container.decodeIfPresent([String: RaceSummary].self, forKey: .raceSummaries)
        }
    }
}
