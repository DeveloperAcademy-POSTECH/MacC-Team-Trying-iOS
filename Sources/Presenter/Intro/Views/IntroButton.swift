//
//  IntroButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class IntroButton: BaseButton {

    /// 버튼 loading 프로퍼티
    var loading: Bool = false {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }

    /// 버튼 title
    var title: String = "" {
        didSet {
            configuration?.title = title
        }
    }

    override func setAttribute() {
        super.setAttribute()
        var configuration = UIButton.Configuration.filled()
        configuration.activityIndicatorColorTransformer = .grayscale
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .designSystem(weight: .bold, size: ._15)
            return outgoing
        }
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .designSystem(.mainYellow)
        configuration.baseForegroundColor = .black
        self.configuration = configuration
        setConfigurationUpdateHandler()
    }

    override func setLayout() {
        super.setLayout()

        self.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
    }

    private func setConfigurationUpdateHandler() {
        self.configurationUpdateHandler = { [weak self] button in

            guard let self = self else { return }
            var newConfiguration = button.configuration
            newConfiguration?.showsActivityIndicator = self.loading
            newConfiguration?.title = self.loading ? nil : self.title
            self.configuration = newConfiguration
        }
    }
}
