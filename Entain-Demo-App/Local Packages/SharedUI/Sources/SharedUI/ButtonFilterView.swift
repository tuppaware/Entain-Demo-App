//
//  RaceFilterView.swift
//  SharedUI
//
//  Created by Adam Ware on 5/11/2024.
//

import SwiftUI

public struct ButtonFilterDisplayModel {
    
    public let buttons: [ButtonFilterDisplayModel.ButtonModel]
    
    public struct ButtonModel: Identifiable {
        public let id: UUID = UUID()
        public let title: String
        public let isSelected: Bool
        public let image: Image?
        
        public init(
            title: String,
            isSelected: Bool,
            image: Image? = nil
        ) {
            self.title = title
            self.isSelected = isSelected
            self.image = image
        }
    }
    
    public init(buttons: [ButtonFilterDisplayModel.ButtonModel]) {
        self.buttons = buttons
    }
}

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
                .buttonStyle(PurpleButtonStyle())
                .frame(minHeight: 42, maxHeight: 42)
            }
        }
        .padding(.vertical, 16)
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

