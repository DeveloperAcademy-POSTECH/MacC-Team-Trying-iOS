//
//  MainButton.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

enum MainButtonType {
    /// 다음 버튼
    /// - Title : 다음
    /// - Height : 58
    case next
    
    /// 확인 버튼
    /// - Title : 확인
    /// - Height : 58
    case done
}

final class MainButton: UIButton {
    var type: MainButtonType
    
    override var isEnabled: Bool {
        didSet {
             self.backgroundColor = self.isEnabled ? .designSystem(.mainYellow) : .designSystem(.grayC5C5C5)
        }
    }
    
    init(type: MainButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        switch type {
        case .next:
            self.setTitle("다음", for: .normal)
            
        case .done:
            self.setTitle("확인", for: .normal)
        }
        self.setTitleColor(.designSystem(.black), for: .normal)
        self.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
        self.layer.cornerRadius = 15
        self.isEnabled = true
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
    }
}
