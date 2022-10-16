//
//  UIFont+.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIFont {
    class func designSystem(weight: Font.Weight, size: Font.Size) -> UIFont {
        .systemFont(ofSize: size.rawValue, weight: weight.real)
    }
    
    private static func _font(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}
