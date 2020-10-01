//
//  TapticHelper.swift
//  Eco Connect
//
//  Created by Nika Kirkitadze on 8/21/20.
//  Copyright © 2020 Capital Group. All rights reserved.
//

import UIKit
import Foundation

struct Taptic {
    /**
     Creates an error Taptic feedback
     */
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /**
     Creates a success Taptic feedback
     */
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /**
     Creates a warning Taptic feedback
     */
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /**
     Creates a light Taptic feedback
     */
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /**
     Creates a medium Taptic feedback
     */
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /**
     Creates a heavy Taptic feedback
     */
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        generator.prepare()
    }
}
