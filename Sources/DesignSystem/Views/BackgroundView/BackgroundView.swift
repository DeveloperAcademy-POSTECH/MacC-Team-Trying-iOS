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
    let starCount: Int = 40
    let duration: CGFloat = 5
    var firstStarLayers = [CALayer]()
    var secondStarLayers = [CALayer]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.9)
        gradientLayer.endPoint = CGPoint(x: -0.5, y: 0.2)
        gradientLayer.colors = [
            UIColor.designSystem(.blue110B38)?.cgColor as Any,
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
            astar.path = circlePath.cgPath
            astar.fillColor = UIColor.white.cgColor
            
            astar.frame = .init(origin: generateRandomPosition(), size: starSize)
            firstStarLayers.append(astar)
            
            astar.frame = .init(origin: generateRandomPosition(), size: starSize)
            secondStarLayers.append(astar)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        firstStarLayers.forEach { starLayer in
            layer.addSublayer(starLayer)
            
            let opacityAnimation = generateOpacityAnimation(from: 0.0, to: 0.6)
            starLayer.add(opacityAnimation, forKey: "opacity")
        }
        
        secondStarLayers.forEach { starLayer in
            layer.addSublayer(starLayer)
            
            let opacityAnimation = generateOpacityAnimation(from: 0.6, to: 0.0)
            starLayer.add(opacityAnimation, forKey: "opacity")
        }
    }
}

// MARK: - Helper
extension BackgroundView {
    private func generateOpacityAnimation(from: Double, to: Double) -> CABasicAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        
        opacityAnimation.fromValue = from
        opacityAnimation.toValue = to
        opacityAnimation.timeOffset = duration * Double.random(in: 0...1)
        opacityAnimation.duration = duration
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = true
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        return opacityAnimation
    }
    
    private func generateRandomPosition() -> CGPoint {
        let width = frame.width
        let height = frame.height

        return CGPoint(
            x: CGFloat(UInt32.random(in: 0...UInt32.max)).truncatingRemainder(dividingBy: width),
            y: CGFloat(UInt32.random(in: 0...UInt32.max)).truncatingRemainder(dividingBy: height)
        )
    }
}
