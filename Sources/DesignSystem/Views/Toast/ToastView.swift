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
        backgroundColor: UIColor? = .systemRed,
        messageColor: UIColor? = .white
    ) {
        super.init(frame: .zero)

        self.messageLabel.textColor = .white
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
        self.messageLabel.font = .designSystem(weight: .bold, size: ._17)
        self.messageLabel.textAlignment = .center
        self.titleStackView.axis = .vertical
        self.titleStackView.spacing = 0
        self.titleStackView.alignment = .center
        self.titleStackView.distribution = .fill

        self.addSubview(titleStackView)
        self.titleStackView.addArrangedSubview(messageLabel)
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        self.titleStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
