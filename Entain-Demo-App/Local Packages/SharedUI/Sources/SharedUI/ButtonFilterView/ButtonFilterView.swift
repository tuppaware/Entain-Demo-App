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
        HStack(alignment: .center, spacing: 8) {
            ForEach(displayModel.buttons, id: \.id) { button in
                Button(action: {
                    buttonAction(button.title)
                }) {
                    Text(button.title)
                        .font(.system(size: 14))
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .foregroundColor(.primary)
                        .background(Color.clear)
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(button.title)
                .accessibilityHint("Enables filtering by \(button.title).")
                .buttonStyle(PurpleButtonStyle())
                .frame(minHeight: 42, maxHeight: 42)
            }
        }
        .padding(.vertical, 8)
    }
}

struct PurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary)
            .background(configuration.isPressed ? Color.purple : Color.gray)
            .cornerRadius(16)

    }
}

