//
//  CustomSegmentedControl.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI

// TODO : - magic numbers
public struct CustomSegmentedControl<Tab: TabRepresentable>: View {
    @Namespace private var animation
    public let displayModel: CustomSegmentedDisplayModel<Tab>
    public var buttonAction: (String) -> Void
    @Binding var selectedTab: Tab
    
    public init(
        displayModel: CustomSegmentedDisplayModel<Tab>,
        selectedTab: Binding<Tab>,
        buttonAction: @escaping (String) -> Void
    ) {
        self.displayModel = displayModel
        self._selectedTab = selectedTab
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(displayModel.tabs) { tab in
                ZStack {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.gray)
                            .matchedGeometryEffect(id: "background", in: animation)
                    }
                    Text(tab.displayTitle)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedTab == tab ? .white : .gray)
                }
                .contentShape(Rectangle()) // Makes the entire area tappable
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedTab = tab
                        buttonAction(tab.displayTitle)
                    }
                }
            }
        }
        .background(.regularMaterial)
        .cornerRadius(32)
        .frame(maxWidth: .infinity, maxHeight: 42)
        .padding(.horizontal, 32)
    }
}



//#Preview {
//    CustomSegmentedControl()
//}
