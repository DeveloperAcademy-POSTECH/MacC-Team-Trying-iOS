//
//  SmallRoundButton.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

enum SmallRoundButtonType {
    /// 코스 등록 버튼
    /// - Title : 코스 등록
    /// - Width : 90
    /// - Height : 30
    case addCourse
    
    /// 일정 선택 버튼
    /// - Title : 일정 선택
    /// - Width : 90
    /// - Height : 30
    case selectDate
}

final class SmallRoundButton: UIButton {
    var type: SmallRoundButtonType
    
    init(type: SmallRoundButtonType) {
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
        case .addCourse:
            self.setTitle("코스 등록", for: .normal)
            self.setTitleColor(.designSystem(.black), for: .normal)
            self.backgroundColor = .designSystem(.mainYellow)
            
        case .selectDate:
            self.setTitle("일정 선택", for: .normal)
            self.setTitleColor(.designSystem(.white), for: .normal)
            self.backgroundColor = .designSystem(.black)
            self.layer.borderColor = .designSystem(.white)
            self.layer.borderWidth = 1
        }
        self.layer.cornerRadius = 15
        self.titleLabel?.font = .designSystem(weight: .bold, size: ._13)
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(90)
            make.height.equalTo(30)
        }
    }
}
