//
//  UIImageView+.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
