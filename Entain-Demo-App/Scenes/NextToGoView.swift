//
//  NextToGoView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//
import SwiftUI

struct NextToGoView: View {
    @Bindable var viewModel: NextToGoViewModel
    
    init(viewModel: NextToGoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $viewModel.nextToGoDisplayModel.filter) {
                ForEach(NextToGoDisplayModel.FilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .onAppear() {
            viewModel.refresh()
        }
    }
    
//    // Function to filter races based on the selected filter option
//    func filteredRaces(_ raceData: RaceData) -> [Race] {
//        switch viewModel.nextToGoDisplayModel.filter {
//        case .all:
//            return raceData.races
//        case .greyhoundRacing:
//            return raceData.races.filter { $0.type == .greyhound }
//        case .horseRacing:
//            return raceData.races.filter { $0.type == .horse }
//        case .harnessRacing:
//            return raceData.races.filter { $0.type == .harness }
//        }
//    }
}


//#Preview {
//    NextToGoView()
//}
