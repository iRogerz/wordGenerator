//
//  AppRouter.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/5/27.
//

import Foundation
import SwiftUI

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func reset() {
        path = NavigationPath()
    }
}
