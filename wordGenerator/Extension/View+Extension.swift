//
//  View+Extension.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/5/29.
//

import Foundation
import SwiftUI
import UIKit
import Combine

extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func enablePopGesture() -> some View {
      background(PopGestureEnabler())
  }
}


struct PopGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let nav = controller.navigationController {
                nav.interactivePopGestureRecognizer?.isEnabled = true
                nav.interactivePopGestureRecognizer?.delegate = nil // 讓所有情境都能滑
            }
        }
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

