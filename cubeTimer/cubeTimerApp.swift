//
//  cubeTimerApp.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/1/26.
//

import SwiftUI

@main
struct CubeTimerApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
