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
        self.backgroundColor = .designSystem(.gray767680)
        
        self.tintColor = .designSystem(.white)
        self.text = "내용을 입력해 주세요."
        self.font = .designSystem(weight: .regular, size: ._15)
        self.delegate = self
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력해 주세요." {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해 주세요."
        }
    }
}
