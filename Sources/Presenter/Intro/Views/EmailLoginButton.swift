//
//  EmailLoginButton.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class EmailLoginButton: BaseButton {

    override func setAttribute() {
        super.setAttribute()
        var configuration = UIButton.Configuration.filled()
        configuration.activityIndicatorColorTransformer = .monochromeTint
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 15)
            return outgoing
        }
        configuration.title = "이메일로 로그인"

        configuration.image = .init(.ic_email_login)
        configuration.imagePadding = 30

        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        self.configuration = configuration
    }
}
