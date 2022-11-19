//
//  PaddingLabel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/04.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
           var contentSize = super.intrinsicContentSize
           contentSize.height += padding.top + padding.bottom
           contentSize.width += padding.left + padding.right
           
           return contentSize
       }
}
