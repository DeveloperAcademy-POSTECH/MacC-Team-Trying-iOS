//
//  UITextField+.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

extension UITextField {
    /// UITextField의 leftView image를 설정합니다.
    /// - Parameters:
    ///   - image: leftView에 들어갈 UIImage
    ///   - imageWidth: image width
    ///   - padding: ImageView에 적용할 padding
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
    
    func textPublisher() -> AnyPublisher<String, Never> {
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextField)?.text ?? "" }
                .eraseToAnyPublisher()
        }
    
}
