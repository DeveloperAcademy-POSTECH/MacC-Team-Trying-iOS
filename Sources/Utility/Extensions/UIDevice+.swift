//
//  UIDevice+.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
