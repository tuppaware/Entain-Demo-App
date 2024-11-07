//
//  NextToGoView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//
import SwiftUI
import SharedUI
import NetworkingManager

/// Next to Go View,
struct NextToGoView: View {
    // View Model
    @ObservedObject var viewModel: NextToGoViewModel
    // Display Model
    @ObservedObject var displayModel: NextToGoDisplayModel
    // Default selected Tab
    @State private var selectedTab: NextToGoDisplayModel.FilterOption = .all
    


    init(viewModel: NextToGoViewModel) {
        self.viewModel = viewModel
        self.displayModel = viewModel.nextToGoDisplayModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                HeaderView()
                if displayModel.filteredRacesListDisplayModel.isEmpty {
                    // Display Empty View
                    EmptyStateView() {
                        // Refresh view
                        viewModel.refresh()
                    }
                    Spacer()
                } else {
                    List {
                        Section {
                            ForEach(displayModel.filteredRacesListDisplayModel, id: \.uuid) { raceViewModel in
                                RaceItemView(viewModel: raceViewModel)
                            }
                        } header: {
                            Text(EntainStrings.NextToGo.Section.title)
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            VStack {
                Spacer()
                CustomSegmentedControl(
                    displayModel: displayModel.allFilterDisplayModel,
                    selectedTab: $selectedTab
                ) { title in
                    viewModel.updateFilter(to: .init(rawValue: title) ?? .all)
                }
            }
        }
        .background(Color.accentColor)
    }
}

#Preview {
    let interactor = NextoGoInteractor(
        networkService: NetworkingManager()
    )
    let viewModel = NextToGoViewModel(interactor: interactor)
    NextToGoView(viewModel: viewModel)
}
