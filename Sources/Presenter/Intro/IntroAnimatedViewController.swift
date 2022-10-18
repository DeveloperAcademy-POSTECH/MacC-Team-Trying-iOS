//
//  AnimatedIntroViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class IntroAnimatedViewController: BaseViewController {

    let fastDuration: CGFloat = 0.5
    let fastDelay: CGFloat = 0.3
    let duration: CGFloat = 1.0
    let delay: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shootingStarView.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateInitViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        shootingStarView.stop()
    }

    lazy var shootingStarView = ShootingStarActor(superView: view)
    lazy var leftPlanetImageView = UIImageView()
    lazy var rightPlanetImageView = UIImageView()
}

extension IntroAnimatedViewController {

    private func setUI() {
        setAttribute()
        setLayout()
    }

    private func setAttribute() {
        leftPlanetImageView.alpha = 0
        rightPlanetImageView.alpha = 0
        leftPlanetImageView.image = .init(.img_planet2)
        rightPlanetImageView.image = .init(.img_planet3)
    }

    private func setLayout() {
        view.addSubview(leftPlanetImageView)
        view.addSubview(rightPlanetImageView)

        leftPlanetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(332)
            make.width.equalTo(57)
            make.leading.equalToSuperview().offset(-57)
        }
        rightPlanetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(292)
            make.width.equalTo(82)
            make.trailing.equalToSuperview().offset(82)
        }
    }

    private func animateInitViews() {
        leftPlanetImageView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(-17)
        }
        rightPlanetImageView.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(41)
        }

        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.leftPlanetImageView.alpha = 1
            self.rightPlanetImageView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}
