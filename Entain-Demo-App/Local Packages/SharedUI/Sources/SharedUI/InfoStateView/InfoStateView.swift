//
//  InfoStateView.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI

// Create the SwiftUI view that uses the protocol
public struct InfoStateView<T: InfoStateProtocol>: View {
    
    public var model: T

    public init(model: T) {
        self.model = model
    }

    public var body: some View {
        VStack(spacing: 32) {
            model.image
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            Text(model.title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text(model.description)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: model.primaryCTA) {
                Text(model.primaryCTATitle)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(model.primaryCTAColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// Example of a model conforming to the protocol
struct SampleEmptyState: InfoStateProtocol {
    var image: Image = Image(systemName: "exclamationmark.triangle")
    var title: String = "An Error Occurred"
    var description: String = "We encountered an unexpected error. Please try again later."
    var primaryCTAColor: Color = .secondary
    var primaryCTATitle: String = "Retry"
    var primaryCTA: () -> Void = {
        print("Retry button tapped")
    }
}

// Preview provider for SwiftUI previews
struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        InfoStateView(model: SampleEmptyState())
    }
}
