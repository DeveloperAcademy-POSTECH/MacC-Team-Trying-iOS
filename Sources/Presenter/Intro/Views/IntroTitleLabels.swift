//
//  IntroTitleLabels.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class IntroTitleLabels: BaseView {

    lazy var titleLabel = UILabel()
    lazy var subTitleLabel = UILabel()

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
        }
    }

    override func setAttribute() {
        super.setAttribute()

        titleLabel.textAlignment = .center
        subTitleLabel.textAlignment = .center
        titleLabel.font = .gmarksans(weight: .light, size: ._15)
        subTitleLabel.font = .gmarksans(weight: .medium, size: ._15)
    }

    override func setLayout() {
        super.setLayout()

        addSubview(titleLabel)
        addSubview(subTitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
