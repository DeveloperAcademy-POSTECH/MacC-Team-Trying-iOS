//
//  ToastView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class ToastView: UIView {
    init(
        message: String,
        subTitle: String? = nil,
        backgroundColor: UIColor? = .designSystem(.mainYellow),
        messageColor: UIColor? = .black
    ) {
        super.init(frame: .zero)

        self.messageLabel.textColor = messageColor
        self.messageLabel.text = message
        self.backgroundColor = backgroundColor

        self.setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let messageLabel = UILabel()
    private let titleStackView = UIStackView()
}

extension ToastView {
    private func setUI() {
        self.messageLabel.font = .designSystem(weight: .bold, size: ._13)
        self.messageLabel.textAlignment = .center
        self.titleStackView.axis = .vertical
        self.titleStackView.spacing = 0
        self.titleStackView.alignment = .center
        self.titleStackView.distribution = .fill

        self.addSubview(titleStackView)
        self.titleStackView.addArrangedSubview(messageLabel)
        self.layer.cornerRadius = 23
        self.layer.masksToBounds = true
        self.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        self.titleStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(27)
        }
    }
}
