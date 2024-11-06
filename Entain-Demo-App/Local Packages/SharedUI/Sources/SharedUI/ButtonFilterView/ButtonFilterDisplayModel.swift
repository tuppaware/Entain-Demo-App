//
//  ButtonFilterDisplayModel.swift
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
