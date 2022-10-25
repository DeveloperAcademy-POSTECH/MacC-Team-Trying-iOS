//
//  AnimatedIntroViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class PlanetAnimatedViewController<VM: BusinessLogic>: IntroBaseViewController<VM> {

    let fastDuration: CGFloat = 0.25
    let fastDelay: CGFloat = 0.3
    let duration: CGFloat = 1.0
    let delay: CGFloat = 1.0

    lazy var shootingStarView = ShootingStarActor(superView: view)
    lazy var leftPlanetImageView = UIImageView()
    lazy var rightPlanetImageView = UIImageView()

    var enterAnimator: UIViewPropertyAnimator?
    var leaveAnimator: UIViewPropertyAnimator?
    var enterWithPlanetAnimator: UIViewPropertyAnimator?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        shootingStarView.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupAnimation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        shootingStarView.stop()
    }

    override func setAttribute() {
        super.setAttribute()

        leftPlanetImageView.alpha = 0
        rightPlanetImageView.alpha = 0
        leftPlanetImageView.image = .init(.img_planet2)
        rightPlanetImageView.image = .init(.img_planet3)
        setNavigationBar()
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(leftPlanetImageView)
        view.addSubview(rightPlanetImageView)

        leftPlanetImageView.frame = CGRect(
            origin: .init(x: -57, y: DeviceInfo.screenHeight - view.safeAreaInsets.bottom - 352),
            size: .init(width: 57, height: 56)
        )
        rightPlanetImageView.frame = CGRect(
            origin: .init(x: DeviceInfo.screenWidth, y: DeviceInfo.screenHeight - view.safeAreaInsets.bottom - 312),
            size: .init(width: 82, height: 42)
        )
    }
}

extension PlanetAnimatedViewController {

    private func setupAnimation() {

        enterAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.5) {
            self.leftPlanetImageView.transform = CGAffineTransform(translationX: 37, y: 0)
            self.rightPlanetImageView.transform = CGAffineTransform(translationX: -51, y: 0)
            self.leftPlanetImageView.alpha = 1
            self.rightPlanetImageView.alpha = 1
        }

        leaveAnimator = UIViewPropertyAnimator(duration: fastDuration, curve: .easeOut) {
            self.leftPlanetImageView.transform = .identity
            self.rightPlanetImageView.transform = .identity
            self.leftPlanetImageView.alpha = 0
            self.rightPlanetImageView.alpha = 0
        }
    }

    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.gmarksans(weight: .bold, size: ._17),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let backButton = UIBarButtonItemAppearance()
        appearance.backButtonAppearance = backButton
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "로그인"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
    }
}
