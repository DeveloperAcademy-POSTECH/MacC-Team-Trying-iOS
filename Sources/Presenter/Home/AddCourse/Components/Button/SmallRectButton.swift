//
//  SmallRectButton.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

enum SmallRectButtonType {
    /// 코스 추가 버튼
    /// - Title : 코스추가
    /// - Width: 70
    /// - Height : 30
    case add
    
    /// 취소 버튼
    /// - Title : 취소
    /// - Width: 70
    /// - Height : 30
    case cancel
}

final class SmallRectButton: UIButton {
    var type: SmallRectButtonType
    
    init(type: SmallRectButtonType) {
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
        case .add:
            self.setTitle("코스추가", for: .normal)
            self.layer.borderColor = .designSystem(.mainYellow)
            
        case .cancel:
            self.setTitle("취소", for: .normal)
            self.layer.borderColor = .designSystem(.red)
        }
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.setTitleColor(.designSystem(.white), for: .normal)
        self.titleLabel?.font = .designSystem(weight: .bold, size: ._13)
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
}
