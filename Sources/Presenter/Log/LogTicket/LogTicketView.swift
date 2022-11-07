//
//  LogTicketView.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class LogTicketView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 18
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        drawTicket()
    }
}

extension LogTicketView {
    private func drawTicket() {
        // 1. CAShapeLayer 선언
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
        ticketShapeLayer.fillColor = UIColor.white.cgColor
        
        let ticketShapePath = UIBezierPath(roundedRect: ticketShapeLayer.bounds, cornerRadius: 18)
        
        let topLeftArcPath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: ticketShapeLayer.bounds.size.height / 4.5),
            radius: 36 / 2,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi / 2 + Double.pi),
            clockwise: false
        )
        topLeftArcPath.close()
        
        let topRightArcPath = UIBezierPath(
            arcCenter: CGPoint(
                x: ticketShapeLayer.frame.width,
                y: ticketShapeLayer.bounds.size.height / 4.5
            ),
            radius: 36 / 2,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi + Double.pi / 2),
            clockwise: true
        )
        topRightArcPath.close()
        
        let bottomRightArcPath = UIBezierPath(
            arcCenter: CGPoint(
                x: ticketShapeLayer.frame.width,
                y: ticketShapeLayer.bounds.size.height / 1.3
            ),
            radius: 36 / 2,
            startAngle: CGFloat( Double.pi / 2 ),
            endAngle: CGFloat(Double.pi + Double.pi / 2),
            clockwise: true
        )
        bottomRightArcPath.close()
        
        let bottomLeftArcPath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: ticketShapeLayer.bounds.size.height / 1.3),
            radius: 36 / 2,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi / 2 + Double.pi),
            clockwise: false
        )
        bottomRightArcPath.close()
        
        let lineShapeLayer = CAShapeLayer()
        
        lineShapeLayer.strokeColor = UIColor.systemGray4.cgColor
        lineShapeLayer.lineWidth = 3
        lineShapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.addLines(
            between: [
                CGPoint(x: 18, y: ticketShapeLayer.bounds.size.height / 1.3),
                CGPoint(x: ticketShapeLayer.bounds.size.width - 18, y: ticketShapeLayer.bounds.size.height / 1.3)
            ]
        )
        
        path.addLines(
            between: [
                CGPoint(x: 18, y: ticketShapeLayer.bounds.size.height / 4.5),
                CGPoint(x: ticketShapeLayer.bounds.size.width - 18, y: ticketShapeLayer.bounds.size.height / 4.5)
            ]
        )
        
        lineShapeLayer.path = path
        
        ticketShapePath.append(topLeftArcPath)
        ticketShapePath.append(topRightArcPath.reversing())
        ticketShapePath.append(bottomLeftArcPath)
        ticketShapePath.append(bottomRightArcPath.reversing())
        ticketShapeLayer.path = ticketShapePath.cgPath
        
        layer.addSublayer(ticketShapeLayer)
        layer.addSublayer(lineShapeLayer)
        
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }
}
