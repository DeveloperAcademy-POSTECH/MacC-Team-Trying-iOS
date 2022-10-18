//
//  FindPasswordButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class FindPasswordButton: BaseButton {

    override func setAttribute() {
        super.setAttribute()
        let attributedString = NSMutableAttributedString()
            .regular(string: "비밀번호 ", fontSize: 13)
            .bold(string: "찾기", fontSize: 13)
        self.setAttributedTitle(attributedString, for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
}
