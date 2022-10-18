//
//  IntroButton.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class IntroButton: UIButton {

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setConfigurationUpdateHandler()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IntroButton {
    private func setUI() {
        var configuration = UIButton.Configuration.filled()
        configuration.activityIndicatorColorTransformer = .monochromeTint
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 15)
            return outgoing
        }
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .designSystem(.mainYellow)
        configuration.baseForegroundColor = .black
        self.configuration = configuration
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
