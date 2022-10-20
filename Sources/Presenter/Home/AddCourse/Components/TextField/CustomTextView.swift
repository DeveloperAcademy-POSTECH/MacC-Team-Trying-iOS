//
//  CustomTextView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class CustomTextView: UITextView {
    init() {
        super.init(frame: .zero, textContainer: nil)
        
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.autocorrectionType = .no
        self.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
        self.layer.cornerRadius = 15
        self.textColor = .designSystem(.white)
        self.backgroundColor = .designSystem(.white)?.withAlphaComponent(0.1)
        self.tintColor = .designSystem(.white)
        self.text = "내용을 입력해 주세요."
        self.font = .designSystem(weight: .regular, size: ._15)
    }
}
