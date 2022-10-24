//
//  AlreadyHaveInvitationButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class AlreadyHaveInvitationButton: BaseButton {

    override func setAttribute() {
        super.setAttribute()
        let signUpAttributedString = NSMutableAttributedString()
            .bold(string: "초대 코드가 ", fontSize: 13)
            .regular(string: "있으신가요?", fontSize: 13)
        self.setAttributedTitle(signUpAttributedString, for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
}
