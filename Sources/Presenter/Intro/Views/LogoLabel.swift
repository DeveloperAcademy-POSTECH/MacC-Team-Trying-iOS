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
        self.text = "우주라이크"
        self.textAlignment = .center
        self.font = .gmarksans(weight: .bold, size: ._30)
    }
}
