//
//  RaceForm.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//

import Foundation

/// Part of the larger RaceData structure
struct RaceForm: Codable {
    let distance: Int?
    let distanceType: DistanceType?
    let distanceTypeId: String?
    let trackCondition: TrackCondition?
    let trackConditionId: String?
    let weather: Weather?
    let weatherId: String?
    let raceComment: String?
    let additionalData: String?
    let generated: Int?
    let silkBaseUrl: String?
    let raceCommentAlternative: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case distanceType = "distance_type"
        case distanceTypeId = "distance_type_id"
        case trackCondition = "track_condition"
        case trackConditionId = "track_condition_id"
        case weather
        case weatherId = "weather_id"
        case raceComment = "race_comment"
        case additionalData = "additional_data"
        case generated
        case silkBaseUrl = "silk_base_url"
        case raceCommentAlternative = "race_comment_alternative"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        distance = try container.decodeIfPresent(Int.self, forKey: .distance)
        distanceType = try container.decodeIfPresent(DistanceType.self, forKey: .distanceType)
        distanceTypeId = try container.decodeIfPresent(String.self, forKey: .distanceTypeId)
        trackCondition = try container.decodeIfPresent(TrackCondition.self, forKey: .trackCondition)
        trackConditionId = try container.decodeIfPresent(String.self, forKey: .trackConditionId)
        weather = try container.decodeIfPresent(Weather.self, forKey: .weather)
        weatherId = try container.decodeIfPresent(String.self, forKey: .weatherId)
        raceComment = try container.decodeIfPresent(String.self, forKey: .raceComment)
        additionalData = try container.decodeIfPresent(String.self, forKey: .additionalData)
        generated = try container.decodeIfPresent(Int.self, forKey: .generated)
        silkBaseUrl = try container.decodeIfPresent(String.self, forKey: .silkBaseUrl)
        raceCommentAlternative = try container.decodeIfPresent(String.self, forKey: .raceCommentAlternative)
    }
}

struct DistanceType: Codable {
    let id: String?
    let name: String?
    let shortName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
    }
}

struct TrackCondition: Codable {
    let id: String?
    let name: String?
    let shortName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
    }
}

struct Weather: Codable {
    let id: String?
    let name: String?
    let shortName: String?
    let iconUri: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
        case iconUri = "icon_uri"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
        iconUri = try container.decodeIfPresent(String.self, forKey: .iconUri)
    }
}
