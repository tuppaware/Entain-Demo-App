//
//  NextToGoView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 5/11/2024.
//
import SwiftUI
import SharedUI
import NetworkingManager

struct NextToGoView: View {
    @ObservedObject var viewModel: NextToGoViewModel

    var body: some View {
        VStack() {
            Label(
                title: {
                    Text(EntainStrings.NextToGo.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                },
                icon: {
                    Image(.nextToGo)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                }
            )
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black)
            
            ButtonFilterView(displayModel: viewModel.nextToGoDisplayModel.allFilterDisplayModel) { title in
                print("tapped \(title)")
            }

            let raceData = viewModel.nextToGoDisplayModel.filteredRacesListDisplayModel
            if raceData.isEmpty {
                Text("No races available.")
                Spacer()
            } else {
                List {
                    ForEach(raceData, id: \.uuid) { raceViewModel in
                        RaceItemView(viewModel: raceViewModel)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
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
