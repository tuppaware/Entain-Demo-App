//
//  EmptyStateView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI
import SharedUI

/// Empty State View Model that conforms to InfoStateProtocol
struct EmptyStateViewModel: InfoStateProtocol {
    var image = Image(.infoState)
    var title = EntainStrings.InfoState.NoRaces.title
    var description = EntainStrings.InfoState.NoRaces.description
    var primaryCTAColor = Color(.blueAccent)
    var primaryCTATitle = EntainStrings.InfoState.NoRaces.PrimaryCTA.title
    private(set) var primaryCTA: () -> Void
    
    init (primaryCTA: @escaping () -> Void) {
        self.primaryCTA = primaryCTA
    }
}

/// Empty State View
struct EmptyStateView: View {
    private(set) var viewModel: EmptyStateViewModel
    
    /// Empty State View - with Primary Button Closure
    /// - Parameter primaryCTA: closure
    init(primaryCTA: @escaping () -> Void) {
        self.viewModel = EmptyStateViewModel(primaryCTA: primaryCTA)
    }
    
    var body: some View {
        InfoStateView(model: viewModel)
    }
}
