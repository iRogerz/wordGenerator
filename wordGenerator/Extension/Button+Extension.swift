//
//  Button+Extension.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/5/10.
//

import Foundation
import SwiftUI

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct OutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .bold))
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Color.Background.yellow)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .stroke(Color.Primary.deepBlue, lineWidth: 6)
            )
            .cornerRadius(16)
            .foregroundColor(.Primary.deepBlue)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}
