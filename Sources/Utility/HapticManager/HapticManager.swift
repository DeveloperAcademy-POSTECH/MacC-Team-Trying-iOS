//
//  HapticManager.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

final class HapticManager {
    static let instance = HapticManager()
    
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
