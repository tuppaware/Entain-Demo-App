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
                },
                icon: {
                    Image(.nextToGo)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                }
            )
            .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.black)
    }
}
