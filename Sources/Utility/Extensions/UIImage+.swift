//
//  UIImage+.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(_ name: AssetName) {
        self.init(named: name.rawValue)
    }
    /// UIImage의 크기를 조정해줍니다.
    /// - Parameter size: 줄이고자하는 size
    /// - Returns: 줄여진 size의 UIImage
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
