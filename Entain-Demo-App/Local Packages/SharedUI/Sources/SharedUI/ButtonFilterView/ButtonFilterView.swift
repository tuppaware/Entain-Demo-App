//
//  RaceFilterView.swift
//  SharedUI
//
//  Created by Adam Ware on 5/11/2024.
//

import SwiftUI

public struct ButtonFilterView: View {
    public let displayModel: ButtonFilterDisplayModel
    public var buttonAction: (String) -> Void
    
    public init(
        displayModel: ButtonFilterDisplayModel,
        buttonAction: @escaping (String) -> Void
    ) {
        self.displayModel = displayModel
        self.buttonAction = buttonAction
    }

    public var body: some View {
        HStack(alignment: .center) {
            ForEach(displayModel.buttons, id: \.id) { button in
                Button(action: {
                    buttonAction(button.title)
                    
                }) {
                    HStack{
                        Image(systemName: button.isSelected ? "checkmark.square.fill" : "square")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                        button.image
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(maxWidth: 25, maxHeight: 25)
                    }
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(button.title)
                .accessibilityHint("Enables filtering by \(button.title).")
                .frame(maxWidth: .infinity, minHeight: 42)
                .padding(.horizontal, 4)
            }
            
        }
        .padding(4)
        .frame(maxWidth: .infinity)
    }
}

struct PurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary)
            .cornerRadius(4)
    }
}

