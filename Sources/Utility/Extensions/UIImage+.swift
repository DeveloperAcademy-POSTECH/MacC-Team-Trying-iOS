//
//  UIImage+.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/26.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
