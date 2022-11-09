//
//  TermViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class NoBusinessLogic: BusinessLogic {}

final class TermViewController: IntroBaseViewController<NoBusinessLogic> {

    lazy var scrollView = UIScrollView()
    lazy var textImageView = UIImageView()

    var navigationTitle: String?

    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = navigationTitle
        scrollView.backgroundColor = .clear
        textImageView.contentMode = .scaleAspectFit
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(scrollView)
        scrollView.addSubview(textImageView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
