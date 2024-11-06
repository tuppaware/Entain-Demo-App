//
//  RaceSummary.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 4/11/2024.
//
import Foundation

/// Part of the larger RaceData structure
struct RaceSummary: Codable {
    let raceId: String
    let raceName: String
    let raceNumber: Int
    let meetingId: String
    let meetingName: String
    let categoryId: String
    let advertisedStart: AdvertisedStart
    // let raceForm: RaceForm?
    let venueId: String
    let venueName: String
    let venueState: String
    let venueCountry: String
    
    enum CodingKeys: String, CodingKey {
        case raceId = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingId = "meeting_id"
        case meetingName = "meeting_name"
        case categoryId = "category_id"
        case advertisedStart = "advertised_start"
        // case raceForm = "race_form"
        case venueId = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        raceId = try container.decodeIfPresent(String.self, forKey: .raceId) ?? ""
        raceName = try container.decodeIfPresent(String.self, forKey: .raceName) ?? ""
        raceNumber = try container.decodeIfPresent(Int.self, forKey: .raceNumber) ?? 0
        meetingId = try container.decodeIfPresent(String.self, forKey: .meetingId) ?? ""
        meetingName = try container.decodeIfPresent(String.self, forKey: .meetingName) ?? ""
        categoryId = try container.decodeIfPresent(String.self, forKey: .categoryId) ?? ""
        advertisedStart = try container.decodeIfPresent(AdvertisedStart.self, forKey: .advertisedStart) ?? .init(seconds: 0)
        // raceForm = try container.decodeIfPresent(RaceForm.self, forKey: .raceForm)
        venueId = try container.decodeIfPresent(String.self, forKey: .venueId) ?? ""
        venueName = try container.decodeIfPresent(String.self, forKey: .venueName) ?? ""
        venueState = try container.decodeIfPresent(String.self, forKey: .venueState) ?? ""
        venueCountry = try container.decodeIfPresent(String.self, forKey: .venueCountry) ?? ""
    }
    
    struct AdvertisedStart: Codable {
        let seconds: Double
    }
}
