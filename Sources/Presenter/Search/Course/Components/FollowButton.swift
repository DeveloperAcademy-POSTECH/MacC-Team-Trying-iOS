//
//  FollowButton.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/13.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
// Init시 setButtonDetailConfiguration, addTarget함수를 사용하시면 됩니다.
class FollowButton: UIButton {
    
    private var isFollow = false
    
    convenience init() {
        self.init(frame: .zero)
        setButtonCommonConfiguration()
    }
    
    private func setButtonCommonConfiguration() {
        var configuration = UIButton.Configuration.filled()
        var background = configuration.background
        var container = AttributeContainer()
        container.font = .designSystem(weight: .bold, size: ._11)
        configuration.attributedTitle = AttributedString("팔로우", attributes: container)
        configuration.contentInsets = .init(top: 8, leading: 18, bottom: 8, trailing: 18)
        background.cornerRadius = 12.5
        background.strokeWidth = 1.25
        
        configuration.background = background
        self.configuration = configuration
        
//        setConfigurationHandler()
    }
//
//    private func setConfigurationHandler() {
//        configurationUpdateHandler = { _ in
//            self.setButtonDetailConfiguration(isFollow: !self.isFollow)
//        }
//    }
    
    func setButtonDetailConfiguration(isFollow: Bool) {
        self.isFollow = isFollow
        var background = self.configuration?.background
    
        self.configuration?.baseForegroundColor = isFollow ? .designSystem(.mainYellow) : .designSystem(.black)
        self.configuration?.baseBackgroundColor = isFollow ? .clear : .designSystem(.gray818181)
        background?.strokeColor = isFollow ? .designSystem(.mainYellow) : .designSystem(.gray818181)
        self.configuration?.background = background ?? .clear()
    }
}
