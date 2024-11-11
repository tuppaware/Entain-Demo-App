//
//  CustomSegmentedControl.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI

/// A custom segmented control that displays tabs conforming to `TabRepresentable`, allowing users to switch between different options.
/// Supports displaying icons or text for each tab and handles selection with animations.
public struct CustomSegmentedControl<Tab: TabRepresentable>: View {
    
    // MARK: - Properties
    
    /// Namespace for the matched geometry effect animation
    @Namespace private var animation
    
    /// The model containing the tabs to be displayed
    public let displayModel: CustomSegmentedDisplayModel<Tab>
    
    /// Action to perform when a tab is selected
    public var buttonAction: (String) -> Void
    
    /// Binding to the currently selected tab
    @Binding var selectedTab: Tab
    
    // Constants to standardize the sizes and spacings used in the view
    private let cornerRadius: CGFloat = 32
    private let iconPadding: CGFloat = 2
    private let minHeight: CGFloat = 46
    private let horizontalPadding: CGFloat = 32
    
    // MARK: - Initializer
    
    /// Initializes the custom segmented control with the provided display model, selected tab binding, and action.
    /// - Parameters:
    ///   - displayModel: The model containing the tabs to display.
    ///   - selectedTab: A binding to the currently selected tab.
    ///   - buttonAction: The action to perform when a tab is selected.
    public init(
        displayModel: CustomSegmentedDisplayModel<Tab>,
        selectedTab: Binding<Tab>,
        buttonAction: @escaping (String) -> Void
    ) {
        self.displayModel = displayModel
        self._selectedTab = selectedTab
        self.buttonAction = buttonAction
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ForEach(displayModel.tabs) { tab in
                    ZStack {
                        // Highlight the background of the selected tab with an animation
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(Color.gray)
                                .matchedGeometryEffect(id: "background", in: animation)
                        }
                        // Display an icon if the tab has one
                        if let icon = tab.displayIcon {
                            icon
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .padding(iconPadding)
                                .foregroundColor(selectedTab == tab ? .white : .black)
                                .accessibilityAddTraits(.isButton)
                                .accessibilityLabel(Text(tab.displayTitle))
                                .accessibilityValue(selectedTab == tab ? "Selected" : "Not selected")
                                .accessibilityHint(Text("Tap to select \(tab.displayTitle)"))
                        } else {
                            // Otherwise, display the tab's title as text
                            Text(tab.displayTitle)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == tab ? .white : .black)
                                .accessibilityAddTraits(.isButton)
                                .accessibilityLabel(Text(tab.displayTitle))
                                .accessibilityValue(selectedTab == tab ? "Selected" : "Not selected")
                                .accessibilityHint(Text("Tap to select \(tab.displayTitle)"))
                        }
                    }
                    .contentShape(Rectangle()) // Makes the entire area tappable

                    .accessibilityAddTraits(.isButton)
                    .frame(maxWidth: .infinity, minHeight: minHeight)
                    .onTapGesture {
                        // Animate the selection change
                        withAnimation(.easeInOut) {
                            selectedTab = tab
                            buttonAction(tab.displayTitle)
                        }
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .cornerRadius(cornerRadius)
            .frame(maxWidth: .infinity, maxHeight: minHeight)
            .padding(.horizontal, horizontalPadding)
        }
        .accessibilityElement(children: .contain)
    }
}

