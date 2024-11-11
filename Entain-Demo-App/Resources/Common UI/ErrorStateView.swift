//
//  ErrorStateViewModel.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI
import SharedUI

/// Error State View Model that conforms to InfoStateProtocol
struct ErrorStateViewModel: InfoStateProtocol {
    var image = Image(.infoState)
    var title = EntainStrings.InfoState.Error.title
    var description: String
    var primaryCTAColor = Color(.blueAccent)
    var primaryCTATitle = EntainStrings.InfoState.Error.PrimaryCTA.title
    private(set) var primaryCTA: () -> Void
    
    init(
        primaryCTA: @escaping () -> Void,
        errorDescription: String
    ) {
        self.primaryCTA = primaryCTA
        description = EntainStrings.InfoState.Error.description(errorDescription)
    }
}

/// Error State View
struct ErrorStateView: View {
    private(set) var viewModel: ErrorStateViewModel
    
    /// Empty State View - with Primary Button Closure
    /// - Parameter primaryCTA: closure
    init(
        errorDescription: String = "",
        primaryCTA: @escaping () -> Void
    ) {
        self.viewModel = ErrorStateViewModel(
            primaryCTA: primaryCTA,
            errorDescription: errorDescription
        )
    }
    
    var body: some View {
        InfoStateView(model: viewModel)
    }
}
