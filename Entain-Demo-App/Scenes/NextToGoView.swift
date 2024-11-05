//
//  NextToGoView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//
import SwiftUI
import SharedUI

struct NextToGoView: View {
    @ObservedObject var viewModel: NextToGoViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                ButtonFilterView(displayModel: viewModel.nextToGoDisplayModel.allFilterDisplayModel) { title in 
                    print("tapped")
                }

                if let raceData = viewModel.nextToGoDisplayModel.currentRaces {
                    List {
                        ForEach(filteredRaces(raceData) ?? [], id: \.meetingId) { value in
                            Text(value.raceName ?? "")
                        }
                    }
                } else {
                    Text("No races available.")
                }
            }
        }
    }

    private func filteredRaces(_ raceData: RaceData) -> [RaceSummary]? {
        switch viewModel.nextToGoDisplayModel.filter {
        case .all:
            return raceData.data?.raceSummaries?.compactMap({ $0.value })
        case .greyhoundRacing:
            return raceData.data?.raceSummaries?.compactMap({ $0.value })
        case .horseRacing:
            return raceData.data?.raceSummaries?.compactMap({ $0.value })
        case .harnessRacing:
            return raceData.data?.raceSummaries?.compactMap({ $0.value })
        }
    }
}
