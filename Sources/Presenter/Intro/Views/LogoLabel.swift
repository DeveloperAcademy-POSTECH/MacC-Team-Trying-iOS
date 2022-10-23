//
//  LogoLabel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class LogoLabel: BaseLabel {
    override func setAttribute() {
        super.setAttribute()
        self.text = "맛스타"
        self.textAlignment = .center
        #warning("폰트 수정 필요합니다")
        self.font = .boldSystemFont(ofSize: 25)
    }
}
