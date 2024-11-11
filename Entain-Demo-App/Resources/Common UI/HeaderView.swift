//
//  HeaderView.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI
// Generic Header View for Reuse
struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(
                title: {
                    Text(EntainStrings.NextToGo.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("HeaderTitle")
                },
                icon: {
                    Image(.nextToGo)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .accessibilityIdentifier("HeaderViewIcon")
                }
            )
            .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
        .accessibilityIdentifier("HeaderViewBackground") 
    }
}

// Preview for SwiftUI Canvas
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
