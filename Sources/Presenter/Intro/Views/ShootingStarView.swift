//
//  ShootingStarView.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import Lottie
import SnapKit

final class ShootingStarActor {

    var shootingStar: ShootingStarView?
    var superView: UIView?

    init(superView: UIView? = nil) {
        self.superView = superView
    }
    
    func start() {
        DispatchQueue.main.async { [weak self] in
            let shootingStar = ShootingStarView()
            self?.superView?.addSubview(shootingStar)
            shootingStar.snp.makeConstraints { make in
                make.centerY.centerX.equalToSuperview()
            }
            self?.shootingStar = shootingStar
        }
    }

    func stop() {
        DispatchQueue.main.async { [weak self] in
            self?.shootingStar?.removeFromSuperview()
        }
    }
}

final class ShootingStarView: BaseView {
    lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "shooting-star", bundle: .main)
        animation.loopMode = .loop
        animation.play()
        return animation
    }()

    override func setAttribute() {
        super.setAttribute()
        backgroundColor = .clear
    }
    
    override func setLayout() {
        super.setLayout()

        addSubview(animationView)

        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
