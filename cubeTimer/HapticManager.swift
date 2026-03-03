//
//  HapticManager.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/2/26.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
