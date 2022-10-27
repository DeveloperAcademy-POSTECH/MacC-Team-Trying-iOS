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

    /// View를 화면에 Fade In 시킵니다.
    /// - Parameters:
    ///   - withDuration: Animation Duration
    ///   - onCompletion: Completion handler
    func fadeIn(_ withDuration: TimeInterval, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: withDuration,
                animations: { self.alpha = 1.0 },
                completion: { _ in
                    if let completion = onCompletion {
                        completion()
                    }
                }
            )
        }
    }
    
    /// View를 화면에서 Fade Out 시킵니다.
    /// - Parameters:
    ///   - withDuration: Animation Duration
    ///   - onCompletion: Completion handler
    func fadeOut(_ withDuration: TimeInterval, onCompletion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: withDuration,
                animations: { self.alpha = 0.0 },
                completion: { _ in
                    self.isHidden = true
                    if let completion = onCompletion {
                        completion()
                    }
                }
            )
        }
    }

    /// UIView를 UIImage로 렌더링합니다.
    /// - Returns: UIImage 렌더링 된 UIView
    /// 사용방법: UIView.asImage()
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
