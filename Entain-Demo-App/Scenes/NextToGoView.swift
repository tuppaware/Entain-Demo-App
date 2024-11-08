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
    // View Model - handling binding interactor and error states
    @ObservedObject var viewModel: NextToGoViewModel
    // Display Model - handling data transformation
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
                // Header View
                HeaderView()
                
                // Loading Skeleton View if loading
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
                    
                    // Show races is not loading
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
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            // Segment Control for filters 
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
    let interactor = NextoGoInteractor(
        networkService: NetworkingManager()
    )
    let viewModel = NextToGoViewModel(interactor: interactor)
    NextToGoView(viewModel: viewModel)
}
