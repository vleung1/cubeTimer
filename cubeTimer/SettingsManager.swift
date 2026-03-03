//
//  SettingsManager.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/2/26.
//

import SwiftUI
import Combine

class SettingsManager: ObservableObject {
    @Published var isHapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticsEnabled, forKey: "isHapticsEnabled")
        }
    }
    
    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")
        }
    }

    init() {
        self.isHapticsEnabled = UserDefaults.standard.object(forKey: "isHapticsEnabled") as? Bool ?? true
        self.isSoundEnabled = UserDefaults.standard.object(forKey: "isSoundEnabled") as? Bool ?? true
    }
}
