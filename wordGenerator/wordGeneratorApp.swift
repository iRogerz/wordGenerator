//
//  wordGeneratorApp.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/4/18.
//

import SwiftUI
import SwiftData
import UIKit

@main
struct wordGeneratorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SimpleWord.self,
            IdiomWord.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
