//
//  InvitationCodeButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class InvitationCodeButton: BaseButton {

    var invitationCode: String = "" {
        didSet {
            configuration?.title = "초대코드 : \(invitationCode)"
        }
    }

    override func setAttribute() {
        super.setAttribute()
        var configuration = UIButton.Configuration.filled()
        configuration.activityIndicatorColorTransformer = .monochromeTint
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .designSystem(weight: .bold, size: ._15)
            return outgoing
        }
        configuration.baseBackgroundColor = .clear
        configuration.title = "초대코드 : "
        configuration.baseForegroundColor = UIColor.designSystem(.mainYellow)
        self.configuration = configuration
        self.layer.borderColor = UIColor.designSystem(.mainYellow)?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
    }

    override func setLayout() {
        super.setLayout()

        self.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
    }
}
