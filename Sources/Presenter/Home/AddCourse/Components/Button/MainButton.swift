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
    /// 코스 추가하기 버튼
    /// - Title : 코스 추가하러 가기
    /// - Height : 58
    case addCourse
    
    /// 다음 버튼
    /// - Title : 다음
    /// - Height : 58
    case next
    
    /// 확인 버튼
    /// - Title : 확인
    /// - Height : 58
    case done
    
    /// 홈으로 돌아가기 버튼
    /// - Title: 홈으로 돌아가기
    /// - Height : 58
    case home
    
    /// 타이틀이 정해지지 않은 버튼
    /// - Height : 58
    case empty
}

final class MainButton: UIButton {
    var type: MainButtonType
    
    override var isEnabled: Bool {
        didSet {
             self.backgroundColor = self.isEnabled ? .designSystem(.mainYellow) : .designSystem(.gray818181)
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
        case .addCourse:
            self.setTitle("코스 추가하러 가기", for: .normal)
            
        case .next:
            self.setTitle("다음", for: .normal)
            
        case .done:
            self.setTitle("확인", for: .normal)
            
        case .home:
            self.setTitle("홈으로 돌아가기", for: .normal)
            
        case .empty:
            break
        }
        self.setTitleColor(.designSystem(.black), for: .normal)
        self.setTitleColor(.designSystem(.white), for: .disabled)
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
