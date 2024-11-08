//
//  Shimmer.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI

// Shimmer Modifier
struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0.0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let gradient = LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.5),
                            Color.gray.opacity(0.3)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    Rectangle()
                        .fill(gradient)
                        .rotationEffect(.degrees(30))
                        .offset(x: -geometry.size.width * 2 + self.phase)
                        .frame(width: geometry.size.width * 3)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    self.phase = UIScreen.main.bounds.width * 3
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(Shimmer())
    }
}
