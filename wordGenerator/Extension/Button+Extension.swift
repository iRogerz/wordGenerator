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
