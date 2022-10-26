//
//  UIImagePickerController+.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/26.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    func fixCannotMoveEditingBox() {
        if let cropView = cropView,
           let scrollView = scrollView,
           scrollView.contentOffset.y == 0 {
            let top: CGFloat = cropView.frame.minY + self.view.frame.minY
            let bottom = scrollView.frame.height - cropView.frame.height - top
            scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
            
            var offset: CGFloat = 0
            if scrollView.contentSize.height > scrollView.contentSize.width {
                offset = 0.5 * (scrollView.contentSize.height - scrollView.contentSize.width)
            }
            scrollView.contentOffset = CGPoint(x: 0, y: -top + offset)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fixCannotMoveEditingBox()
        }
    }
    
    private var cropView: UIView? {
        findCropView(from: self.view)
    }
    
    private var scrollView: UIScrollView? {
        findScrollView(from: self.view)
    }
    
    private func findCropView(from view: UIView) -> UIView? {
        let width = UIScreen.main.bounds.width
        let size = view.bounds.size
        if width == size.height {
            return view
        }
        for view in view.subviews {
            if let cropView = findCropView(from: view) {
                return cropView
            }
        }
        return nil
    }
    
    private func findScrollView(from view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for view in view.subviews {
            if let scrollView = findScrollView(from: view) {
                return scrollView
            }
        }
        return nil
    }
}
