//
//  RaceItemView.swift
//  SharedUI
//
//  Created by Adam Ware on 6/11/2024.
//

import SwiftUI
import FlagKit

/// A view representing a single race item in a list, displaying race details and countdown timer.
public struct RaceItemView: View {
    
    /// The view model containing data for the race item.
    @ObservedObject var viewModel: RaceItemViewModel
    
    /// Initializes the `RaceItemView` with a given view model.
    /// - Parameter viewModel: The `RaceItemViewModel` containing race information for display.
    public init(viewModel: RaceItemViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack {
            // Left-aligned race image and details
            VStack(alignment: .leading, spacing: 4) {
                viewModel.image
                    .resizable()
                    .frame(maxWidth: 30, maxHeight: 30)
                Text("\(viewModel.meetingName) R\(viewModel.raceNumber)")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Right-aligned countdown and country flag or name
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.countdownString)
                    .foregroundStyle((viewModel.countDownTime ?? 0 > 180) ? .black : .red)
                    .monospacedDigit()
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let image = viewModel.flagCountryCode {
                    image
                        .scaledToFit()
                        .frame(height: 20)
                } else {
                    Text(viewModel.countryName)
                        .font(.footnote)
                        .foregroundColor(.primary)
                }
            }
        }
        // Note: - Accessibitlity label should be localised as well, but to save time in a sepereate package I have omitted it here.
        .accessibilityLabel("Countdown to race start for \(viewModel.meetingName) Race \(viewModel.raceNumber): \(viewModel.countdownString)")
        .padding(.vertical, 8)
        .transition(.opacity)
    }
}


#Preview {
    let vm = RaceItemViewModel(
        raceNumber: 25,
        meetingName: "Meeting name",
        image: Image(uiImage: .checkmark),
        countryName: "countryName",
        timerID: UUID()
    )
    RaceItemView(viewModel: vm)
}
