//
//  IntroButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class IntroButton: BaseButton {

    /// 버튼 title
    var title: String = "" {
        didSet {
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
        }
    }

    override func setAttribute() {
        super.setAttribute()
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.setTitleColor(.black, for: .normal)
        self.setBackgroundColor(.designSystem(.mainYellow)!, for: .normal)
        self.setBackgroundColor(.designSystem(.gray818181)!.withAlphaComponent(0.4), for: .disabled)
    }

    override func setLayout() {
        super.setLayout()

        self.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
    }
}
