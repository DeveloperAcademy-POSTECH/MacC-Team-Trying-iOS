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

    var termType: TermType?

    enum TermType {
        case privacy
        case service

        var title: String? {
            switch self {
            case .privacy:
                return "개인정보처리방침"
            case .service:
                return "서비스 이용약관"
            }
        }

        var image: UIImage? {
            switch self {
            case .privacy:
                return .init(.img_privacy_term)
            case .service:
                return .init(.img_service_term)
            }
        }
    }
    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = termType?.title
        scrollView.backgroundColor = .clear
        textImageView.contentMode = .scaleAspectFit
        textImageView.image = termType?.image
    }

    override func setLayout() {
        super.setLayout()

        guard let termType = termType else { return }

        view.addSubview(scrollView)
        scrollView.addSubview(textImageView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
        textImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.width.equalTo(DeviceInfo.screenWidth - 40)
            make.centerX.equalToSuperview()
            
            switch termType {
            case .service:
                make.height.equalTo((DeviceInfo.screenWidth - 40) * 7652 / 350)
            case .privacy:
                make.height.equalTo((DeviceInfo.screenWidth - 40) * 2957 / 350)
            }
        }
    }
}
