//
//  LoadingView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class LoadingView: BaseView {
    static let shared: LoadingView = LoadingView()

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .designSystem(.mainYellow)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func setAttribute() {
        super.setAttribute()
        backgroundColor = .gray.withAlphaComponent(0.7)
        layer.cornerRadius = 10
    }

    override func setLayout() {
        super.setLayout()

        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func show() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }
        window.addSubview(self)
        self.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.center.equalToSuperview()
        }
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.removeFromSuperview()
        }

    }
}
