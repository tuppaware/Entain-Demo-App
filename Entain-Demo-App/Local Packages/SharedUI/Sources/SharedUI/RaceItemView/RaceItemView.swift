//
//  RaceItemView.swift
//  SharedUI
//
//  Created by Adam Ware on 6/11/2024.
//

import SwiftUI

public struct RaceItemView: View {
    
    @ObservedObject
    var viewModel: RaceItemViewModel
    
    public init(viewModel: RaceItemViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                viewModel.image
                    .resizable()
                    .frame(maxWidth: 30, maxHeight: 30)
                Text("\(viewModel.meetingName) R\(viewModel.raceNumber)")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4){
                Text(viewModel.countdownString)
                    .monospacedDigit()
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(viewModel.venueName)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .accessibilityLabel("Countdown to race start \(viewModel.meetingName) R\(viewModel.raceNumber) \(viewModel.countdownString)")
        .padding(.vertical, 8)
    }
}

#Preview {
    let vm = RaceItemViewModel(
        raceNumber: 25,
        meetingName: "Meeting name",
        image: Image(uiImage: .checkmark),
        venueName: "venue",
        timerID: UUID()
    )
    RaceItemView(viewModel: vm)
}
