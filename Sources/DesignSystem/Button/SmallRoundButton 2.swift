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
    
    /// 행성 참가 버튼
    /// - Title : 행성 참가
    /// - Width : 90
    /// - Height : 30
    case enterPlanet
    
    /// 행성 생성 버튼
    /// - Title : 행성 생성
    /// - Width : 90
    /// - Height : 30
    case createPlanet
    
    /// 메이트 초대하기 버튼
    /// - Title : 메이트 초대하기
    /// - Width : 116
    /// - Height : 30
    case inviteMate
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
            
        case .enterPlanet:
            self.setTitle("행성 참가", for: .normal)
            self.setTitleColor(.designSystem(.mainYellow), for: .normal)
            self.backgroundColor = .designSystem(.black)
            self.layer.borderColor = .designSystem(.mainYellow)
            self.layer.borderWidth = 1
            
        case .createPlanet:
            self.setTitle("행성 생성", for: .normal)
            self.setTitleColor(.designSystem(.black), for: .normal)
            self.backgroundColor = .designSystem(.mainYellow)
            
        case .inviteMate:
            self.setTitle("메이트 초대하기", for: .normal)
            self.setTitleColor(.designSystem(.mainYellow), for: .normal)
            self.backgroundColor = .designSystem(.black)
            self.layer.borderColor = .designSystem(.mainYellow)
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
