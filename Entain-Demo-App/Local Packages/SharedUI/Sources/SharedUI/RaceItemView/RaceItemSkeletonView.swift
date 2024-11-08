//
//  RaceItemSkeletonView.swift
//  SharedUI
//
//  Created by Adam Ware on 7/11/2024.
//

import SwiftUI

// Skeleton View for the Loading state
public struct RaceItemSkeletonView: View {
    
    public init (){}
    
    // Generate 5x list item views 
    public var body: some View {
        ForEach(0..<5, id: \.self) { _ in
            SkeletonView()
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .padding(.vertical, 8)
        .transition(.opacity)
    }
    
    struct SkeletonView: View {
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 30, height: 30)
                        .cornerRadius(4)
                        .shimmer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .cornerRadius(4)
                        .shimmer()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 14)
                        .cornerRadius(4)
                        .shimmer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 30, height: 12)
                        .cornerRadius(4)
                        .shimmer()
                }
            }
        }
    }
}
