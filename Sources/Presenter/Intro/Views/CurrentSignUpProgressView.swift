//
//  InvitationProgressView.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class CurrentSignUpProgressView: BaseView {

    let signupLabel = UILabel()
    let createPlanetLabel = UILabel()
    let invitateMateLabel = UILabel()
    let lineView = UIView()
    let signupStar = UIImageView(image: .init(.ic_yellow_star))
    let createPlanetStar = UIImageView(image: .init(.ic_yellow_star))

    var isSetted: Bool = false

    override func setAttribute() {

        [signupLabel, createPlanetLabel, invitateMateLabel].forEach { label in
            label.textColor = .white
            label.font = UIFont.designSystem(weight: .bold, size: ._15)
        }

        signupLabel.text = "회원가입"
        createPlanetLabel.text = "행성생성"
        invitateMateLabel.text = "메이트 초대"

        lineView.backgroundColor = UIColor.designSystem(.orange)
    }

    override func setLayout() {
        addSubview(signupLabel)
        addSubview(createPlanetLabel)
        addSubview(invitateMateLabel)

        signupLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(createPlanetLabel.snp.leading).offset(-60)
        }
        createPlanetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(self.snp.centerX)
        }
        invitateMateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(createPlanetLabel.snp.trailing).offset(58)
        }

        backgroundColor = .clear
        layer.masksToBounds = false
    }

    override func draw(_ rect: CGRect) {

        let linePath = UIBezierPath()
        linePath.move(to: .init(x: 0, y: rect.height))
        linePath.addLine(to: .init(x: rect.width, y: rect.height))

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.designSystem(.orange)?.cgColor
        lineLayer.frame = rect

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.6
        animation.beginTime = CACurrentMediaTime()
        animation.fromValue = 0
        animation.toValue = 1
        animation.repeatCount = 0

        let firstStarPath = UIBezierPath()
        firstStarPath.move(to: .init(x: 0, y: rect.height))
        firstStarPath.addLine(to: .init(x: signupLabel.center.x, y: rect.height))

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            CATransaction.begin()
            let starImage = UIImage(.ic_yellow_star)

            let firstStarLayer = CAShapeLayer()
            firstStarLayer.contents = starImage?.cgImage
            firstStarLayer.frame = .init(origin: .init(x: -10, y: rect.height - 10), size: .init(width: 20, height: 20))

            let secondStarLayer = CAShapeLayer()
            secondStarLayer.contents = starImage?.cgImage
            secondStarLayer.frame = .init(origin: .init(x: -10, y: rect.height - 10), size: .init(width: 20, height: 20))

            let firstStarPosition = CABasicAnimation(keyPath: "position")
            firstStarPosition.fromValue = CGPoint(x: 0, y: rect.height)
            firstStarPosition.isRemovedOnCompletion = false
            firstStarPosition.fillMode = .forwards
            firstStarPosition.duration = 1.0
            firstStarPosition.toValue = CGPoint(x: self.signupLabel.frame.midX, y: rect.height)
            let firstStarRotation = CABasicAnimation(keyPath: "transform.rotation.z")
            firstStarRotation.fromValue = 0
            firstStarRotation.toValue = 360
            firstStarRotation.duration = 1.0
            self.layer.addSublayer(firstStarLayer)
            firstStarLayer.add(firstStarRotation, forKey: nil)
            firstStarLayer.add(firstStarPosition, forKey: nil)

            let secondStarPosition = CABasicAnimation(keyPath: "position")
            secondStarPosition.fromValue = CGPoint(x: 0, y: rect.height)
            secondStarPosition.isRemovedOnCompletion = false
            secondStarPosition.fillMode = .forwards
            secondStarPosition.duration = 1.2
            secondStarPosition.toValue = CGPoint(x: self.createPlanetLabel.frame.midX, y: rect.height)
            let secondStarRotaion = CABasicAnimation(keyPath: "transform.rotation.z")
            secondStarRotaion.fromValue = 0
            secondStarRotaion.toValue = 360
            secondStarRotaion.duration = 1.2
            self.layer.addSublayer(secondStarLayer)
            secondStarLayer.add(secondStarPosition, forKey: nil)
            secondStarLayer.add(secondStarRotaion, forKey: nil)

            CATransaction.commit()
        }
        lineLayer.add(animation, forKey: nil)
        layer.addSublayer(lineLayer)
        CATransaction.commit()

    }
}
