//
//  UIView+.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIView {
    /// 화면에 여러 View들을 추가합니다
    /// - Parameter views: 추가할 View들
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
