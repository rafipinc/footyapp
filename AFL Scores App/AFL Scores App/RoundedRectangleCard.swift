//
//  RoundedRectangleCard.swift
//  AFL Scores App
//
//  Created by PINCUS, Rafael on 25/5/2024.
//

import SwiftUI

struct RoundedRectangleCard: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
            content
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
                .shadow(color: color.opacity(1), radius: 10, x: 0, y: 2)
        }
    }

extension View {
    func roundedRectangleCard() -> some View {
        modifier(RoundedRectangleCard(color: Color.black))
    }
}

