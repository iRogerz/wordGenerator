//
//  ModeButton.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/5/10.
//

import Foundation
import SwiftUI

enum ModeButtonType {
  case left
  case right
}

struct ModeButton: View {
  let title: String
  let image: ImageResource
  let mainColor: Color
  let buttonType: ModeButtonType

  var body: some View {
    HStack {
      if buttonType == .left {
        Text(title.map { String($0) }.joined(separator: "\n"))
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(mainColor)
        Image(image)
          .resizable()
          .frame(width: 200, height: 200)
      } else {
        Image(image)
          .resizable()
          .frame(width: 200, height: 200)
        Text(title.map { String($0) }.joined(separator: "\n"))
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(mainColor)
      }
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.Primary.primary)
    .cornerRadius(10)
    .shadow(color: mainColor, radius: 2, x: 8, y: 8)
  }
}
