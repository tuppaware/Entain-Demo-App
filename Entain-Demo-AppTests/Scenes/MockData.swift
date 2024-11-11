//
//  MockData.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 11/11/2024.
//
import Foundation

struct MockData {
    static let raceDataJSON = """
        {
           "status":200,
           "data":{
              "next_to_go_ids":[
                 "7fbc4326-aef8-4267-acf2-3eeaa5a5d566",
                 "5b10f4e9-54e8-4f40-ab7b-ac7c7c29add5",
                 "f330bce4-e3d7-47d4-bf37-a7c9aa6b8ab0",
                 "3b8deeab-3f39-4e1d-a147-337d7f6904b5",
                 "637f5f3a-300c-482f-b113-53c575801895",
                 "36af3601-bf30-4d62-a137-7c3e00e849cf",
                 "bddb0dc4-c3be-44ae-8f2f-334ed60d4b38",
                 "c20eecb5-34e8-4299-9e9a-0d4abb0624fe",
                 "790b6aa0-6269-4636-8e4f-c4ed224e0e03",
                 "7fd10df9-ca4c-4100-ad9c-a709bf8db62b"
              ],
              "race_summaries":{
                 "36af3601-bf30-4d62-a137-7c3e00e849cf":{
                    "race_id":"36af3601-bf30-4d62-a137-7c3e00e849cf",
                    "race_name":"Race 9 - Allowance Optional Claiming",
                    "race_number":9,
                    "meeting_id":"2462b127-54cd-481c-b0d8-8c0e568adf09",
                    "meeting_name":"Del Mar",
                    "category_id":"4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start":{
                        "seconds": \(Date().timeIntervalSince1970 + 5000) 
                    },
                    "venue_id":"4c901b5f-077e-436d-9044-ce4f58a68323",
                    "venue_name":"Del Mar",
                    "venue_state":"CA",
                    "venue_country":"USA"
                 },
                 "3b8deeab-3f39-4e1d-a147-337d7f6904b5":{
                    "race_id":"3b8deeab-3f39-4e1d-a147-337d7f6904b5",
                    "race_name":"Race 2 - Claiming",
                    "race_number":2,
                    "meeting_id":"79ace5dc-7a00-4ab0-8055-a86cc6498b1f",
                    "meeting_name":"Mountaineer Park",
                    "category_id":"4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start":{
                       "seconds": \(Date().timeIntervalSince1970 + 5000) 
                    },
                    "venue_id":"33612182-29fc-4ddd-91e6-6617d7289d2b",
                    "venue_name":"Mountaineer Park",
                    "venue_state":"WV",
                    "venue_country":"USA"
                 },
                 "5b10f4e9-54e8-4f40-ab7b-ac7c7c29add5":{
                    "race_id":"5b10f4e9-54e8-4f40-ab7b-ac7c7c29add5",
                    "race_name":"Race 2 - 1609M",
                    "race_number":2,
                    "meeting_id":"a3d4687d-94da-4d81-a111-5f1486ea4a84",
                    "meeting_name":"Flamboro Downs",
                    "category_id":"161d9be2-e909-4326-8c2c-35ed71fb460b",
                    "advertised_start":{
                       "seconds": \(Date().timeIntervalSince1970 + 5000) 
                    },
                    "venue_id":"8dd6be42-4608-44a4-87bb-d6c07984be03",
                    "venue_name":"Flamboro Downs",
                    "venue_state":"ON",
                    "venue_country":"CA"
                 },
                 "637f5f3a-300c-482f-b113-53c575801895":{
                    "race_id":"637f5f3a-300c-482f-b113-53c575801895",
                    "race_name":"Book For Xmas Function 12 December Mobile Pace",
                    "race_number":2,
                    "meeting_id":"e80007a1-4767-4443-85cf-ea0164325d72",
                    "meeting_name":"Manawatu",
                    "category_id":"161d9be2-e909-4326-8c2c-35ed71fb460b",
                    "advertised_start":{
                       "seconds": \(Date().timeIntervalSince1970 + 5000) 
                    },
                    "venue_id":"0aac06dc-0f17-4c5f-bb19-1a29d2b4b9d8",
                    "venue_name":"Manawatu",
                    "venue_state":"NZ",
                    "venue_country":"NZ"
                 },
                 "790b6aa0-6269-4636-8e4f-c4ed224e0e03":{
                    "race_id":"790b6aa0-6269-4636-8e4f-c4ed224e0e03",
                    "race_name":"Smart Panel Construction Trot",
                    "race_number":3,
                    "meeting_id":"74d77260-8410-4978-ad7d-86e162aefaf9",
                    "meeting_name":"Kaikoura",
                    "category_id":"161d9be2-e909-4326-8c2c-35ed71fb460b",
                    "advertised_start":{
                       "seconds": \(Date().timeIntervalSince1970 + 5000) 
                    },
                    "venue_id":"588f7e31-8020-424a-ad12-d7dadbe5aa1f",
                    "venue_name":"Kaikoura",
                    "venue_state":"NZ",
                    "venue_country":"NZ"
                 }
              }
           },
           "message":"Next 10 races from each category"
        }
        """.data(using: .utf8)!
}

