//
//  PlanetTextField.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class PlanetTextField: UITextField {

    let lineView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.attributedPlaceholder = NSAttributedString(
            string: "행성이름을 입력해 주세요.",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.designSystem(.grayC5C5C5) ?? .white,
                NSAttributedString.Key.font: UIFont.designSystem(weight: .regular, size: ._15)
            ]
        )

        let imageView = UIImageView(image: .init(.ic_planet_name))
        imageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        imageView.backgroundColor = .clear
        self.leftView = imageView
        self.leftViewMode = .always
        self.textInputView.layer.masksToBounds = false
        
        self.borderStyle = .none
        addSubview(lineView)
        lineView.backgroundColor = .designSystem(.mainYellow)
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        lineView.snp.updateConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}
