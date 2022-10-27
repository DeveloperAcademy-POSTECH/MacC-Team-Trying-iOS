//
//  SignUpButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class SignUpButton: BaseButton {

    override func setAttribute() {
        super.setAttribute()
        let signUpAttributedString = NSMutableAttributedString()
            .regular(string: "아직 회원이 아닌가요? ", fontSize: 13)
            .bold(string: "회원가입", fontSize: 13)
        self.setAttributedTitle(signUpAttributedString, for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
}
