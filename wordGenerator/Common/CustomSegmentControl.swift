//
//  CustomSegmentControl.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/5/10.
//

import Foundation
import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    let titles: [String]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(titles.indices, id: \ .self) { idx in
                Button(action: {
                    selectedIndex = idx
                }) {
                    Text(titles[idx])
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedIndex == idx ? .white : Color.Primary.deepBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                              .fill(selectedIndex == idx ? Color.Primary.orange : Color.Primary.primary)
                        )
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(Color.Primary.deepBlue)
        )
    }
}
