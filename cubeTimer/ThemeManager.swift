//
//  ThemeManager.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/2/26.
//

import Foundation
import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
        }
    }

    var colorScheme: ColorScheme? {
        switch currentTheme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var iconName: String {
        switch currentTheme {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }

    var label: String {
        switch currentTheme {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    init() {
        let saved = UserDefaults.standard.string(forKey: "appTheme") ?? AppTheme.system.rawValue
        self.currentTheme = AppTheme(rawValue: saved) ?? .system
    }

    func cycleTheme() {
        switch currentTheme {
        case .system: currentTheme = .light
        case .light: currentTheme = .dark
        case .dark: currentTheme = .system
        }
    }
}
