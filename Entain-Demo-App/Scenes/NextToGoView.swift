//
//  NextToGoView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//

import SwiftUI
import SharedUI
import NetworkingManager

/// A view displaying the "Next to Go" races, with filtering and loading states.
struct NextToGoView: View {
    // ViewModel handling interaction logic and error states
    @ObservedObject var viewModel: NextToGoViewModel
    
    // DisplayModel transforming and managing data for display
    @ObservedObject var displayModel: NextToGoDisplayModel
    
    // The currently selected filter tab
    @State private var selectedTab: NextToGoDisplayModel.FilterOption = .all
    
    init(viewModel: NextToGoViewModel) {
        self.viewModel = viewModel
        self.displayModel = viewModel.nextToGoDisplayModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                HeaderView()
                
                // Show loading skeleton view if data is loading
                if viewModel.isLoading {
                    List {
                        Section {
                            RaceItemSkeletonView()
                        } header: {
                            Text(EntainStrings.NextToGo.Section.title(selectedTab.displayTitle))
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                } else {
                    // Show race items when not loading
                    List {
                        Section {
                            ForEach(displayModel.filteredRacesListDisplayModel, id: \.uuid) { raceViewModel in
                                RaceItemView(viewModel: raceViewModel)
                            }
                        } header: {
                            HStack {
                                Text(EntainStrings.NextToGo.Section.title(selectedTab.displayTitle))
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            // Filter control for selecting race categories
            CustomSegmentedControl(
                displayModel: displayModel.allFilterDisplayModel,
                selectedTab: $selectedTab
            ) { title in
                viewModel.updateFilter(to: .init(rawValue: title) ?? .all)
            }
        }
        .background(Color.accentColor)
    }
}

#Preview {
    let interactor = NextToGoInteractor(
        networkService: NetworkingManager()
    )
    let viewModel = NextToGoViewModel(interactor: interactor)
    NextToGoView(viewModel: viewModel)
}
