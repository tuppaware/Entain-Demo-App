//
//  RaceItemView.swift
//  SharedUI
//
//  Created by Adam Ware on 6/11/2024.
//

import SwiftUI
import FlagKit

// A view representing a single race item in a list, displaying race details and countdown timer.
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
                    .accessibilityHidden(true) // Mark as decorative if not conveying information
                
                Text("\(viewModel.meetingName) R\(viewModel.raceNumber)")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .accessibilityLabel(Text("\(viewModel.meetingName) Race \(viewModel.raceNumber)"))
            }
            
            Spacer()
            
            // Right-aligned countdown and country flag or name
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.countdownString)
                    .foregroundStyle((viewModel.countDownTime ?? 0 > 180) ? .black : .red)
                    .monospacedDigit()
                    .font(.subheadline)
                    .foregroundColor((viewModel.countDownTime ?? 0 > 180) ? .primary : .red)
                    .accessibilityLabel(Text("Time remaining: \(viewModel.countdownString)"))
                
                if let image = viewModel.flagCountryCode {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .accessibilityLabel(Text("\(viewModel.countryName) Flag"))
                } else {
                    Text(viewModel.countryName)
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .accessibilityLabel(Text("Country: \(viewModel.countryName)"))
                }
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Countdown to race start for \(viewModel.meetingName) Race \(viewModel.raceNumber): \(viewModel.countdownString)"))
        .transition(.opacity)
    }
}

struct RaceItemView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = RaceItemViewModel(
            raceNumber: 25,
            meetingName: "Meeting name",
            image: Image(uiImage: .checkmark),
            countryName: "AUS",
            timerID: UUID()
        )
        RaceItemView(viewModel: vm)
            .previewLayout(.sizeThatFits)
    }
}


