//
//  BackgroundView.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class BackgroundView: UIView {
    let radius = 1
    lazy var starSize = CGSize(width: radius * 2, height: radius * 2)
    let starCount: Int = 30
    let duration: CGFloat = 5
    var starLayers = [CALayer]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.9)
        gradientLayer.endPoint = CGPoint(x: -0.5, y: 0.2)
        gradientLayer.colors = [
            UIColor.designSystem(.blue110B38)?.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)

        let circlePath = UIBezierPath(
            arcCenter: .init(x: radius, y: radius),
            radius: CGFloat(radius),
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        for _ in 0..<starCount {
            let astar = CAShapeLayer()
            astar.frame = .init(origin: generateRandomPosition(), size: starSize)
            astar.path = circlePath.cgPath
            astar.fillColor = UIColor.white.cgColor
            starLayers.append(astar)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        starLayers.forEach { starLayer in
            layer.addSublayer(starLayer)
        }

        starLayers.forEach { starLayer in
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0.2
            opacityAnimation.toValue = 0.8
            opacityAnimation.timeOffset = duration * Double.random(in: 0...1)
            opacityAnimation.duration = duration
            opacityAnimation.repeatCount = .infinity
            opacityAnimation.autoreverses = true
            opacityAnimation.isRemovedOnCompletion = false
            opacityAnimation.fillMode = .forwards

            starLayer.add(opacityAnimation, forKey: "opacity")
        }
    }

    func generateRandomPosition() -> CGPoint {
        let height = frame.height
        let width = frame.width

        return CGPoint(
            x: CGFloat(UInt32.random(in: 0...UInt32.max)).truncatingRemainder(dividingBy: width),
            y: CGFloat(UInt32.random(in: 0...UInt32.max)).truncatingRemainder(dividingBy: height)
        )
    }
}
