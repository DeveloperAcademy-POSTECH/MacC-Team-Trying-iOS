//
//  LoadingIndicator.swift
//  우주라이크
//
//  Created by 김승창 on 2022/11/30.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

final class LoadingIndicator {
    static func showIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .designSystem(.mainYellow)
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
