//
//  FollowButton.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/13.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class FollowButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configuration = FollowButton.updateConfiguration(type: .follow)
            } else {
                configuration = FollowButton.updateConfiguration(type: .unFollow)
            }
        }
    }
    
    convenience init() {
        let configuration = FollowButton.updateConfiguration(type: .follow)
        self.init(configuration: configuration, primaryAction: nil)
    }
    
    private static func updateConfiguration(type: FollowButtonConfiguration) -> Configuration {
        
        var configuration = UIButton.Configuration.filled() // 1
        var background = configuration.background
        var container = AttributeContainer()
        container.font = .boldSystemFont(ofSize: 10)
        configuration.attributedTitle = AttributedString("팔로우", attributes: container)
        configuration.contentInsets = .init(top: 8, leading: 18, bottom: 8, trailing: 18)
        background.cornerRadius = 12.5
        background.strokeWidth = 1.25
        
        switch type {
        case .follow:
                configuration.baseForegroundColor = UIColor.yellow
                configuration.baseBackgroundColor = .black
                background.strokeColor = .yellow
        case .unFollow:
                configuration.baseForegroundColor = UIColor.black
                configuration.baseBackgroundColor = .gray
                background.strokeColor = .gray
        }
        configuration.background = background
        return configuration
    }
    
    enum FollowButtonConfiguration {
        case follow
        case unFollow
    }
}
