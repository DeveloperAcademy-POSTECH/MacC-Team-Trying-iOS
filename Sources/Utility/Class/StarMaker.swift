//
//  StarMaker.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

struct StarMaker {
    
    static func makeStars(places: [UserCourseInfo.Coordinates]) -> UIImage? {
        let starView = UIView()
        starView.backgroundColor = .clear
        starView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        let latitudeArray = places.map { CGFloat($0.latitude) }
        let longtitudeArray = places.map { CGFloat($0.longitude) }

        guard let minX = latitudeArray.min() else { return nil }
        guard let maxX = latitudeArray.max() else { return nil }
        guard let minY = longtitudeArray.min() else { return nil }
        guard let maxY = longtitudeArray.max() else { return nil }

        let deltaX: CGFloat = {
            if maxX - minX == 0 {
                return 1
            } else {
                return maxX - minX
            }
        }()

        let deltaY: CGFloat = {
            if maxY - minY == 0 {
                return 1
            } else {
                return maxY - minY
            }
        }()

        let adjustedLatitude = latitudeArray.map { (CGFloat(($0 - minX) / deltaX ) * 200) * 0.8 }
        let adjustedLongtitude = longtitudeArray.map { (CGFloat(($0 - minY) / deltaY) * 200) * 0.8 }

        let xOffset = (200 - abs(adjustedLatitude.max()!)) / 2 - 12.5
        let yOffset = (200 - abs(adjustedLongtitude.max()!)) / 2 - 12.5

        for index in places.indices {
            let imageView = UIImageView()
            let image = UIImage(named: "star")
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.frame = CGRect(x: adjustedLatitude[index] + xOffset, y: adjustedLongtitude[index] + yOffset, width: 25, height: 25)
            imageView.layer.shadowOffset = .zero
            imageView.layer.shadowRadius = 10
            imageView.layer.shadowColor = UIColor.red.cgColor
            imageView.layer.shadowOpacity = 2.0

            starView.addSubview(imageView)

            if index < places.count - 1 {
                let xPan = (adjustedLatitude[index + 1] - adjustedLatitude[index])
                let yPan = (adjustedLongtitude[index + 1] - adjustedLongtitude[index])

                let distance = ((xPan * xPan) + (yPan * yPan)).squareRoot()
                let editX = 13 / distance * xPan
                let editY = 13 / distance * yPan

                let path = UIBezierPath()
                path.move(to: CGPoint(x: adjustedLatitude[index] + imageView.frame.size.width / 2 + editX + xOffset, y: adjustedLongtitude[index] + imageView.frame.size.height / 2 + editY + yOffset))
                path.addLine(to: CGPoint(x: adjustedLatitude[index + 1] + imageView.frame.size.width / 2 - editX + xOffset, y: adjustedLongtitude[index + 1] + imageView.frame.size.height / 2 - editY + yOffset))
                path.lineWidth = 2
                path.lineJoinStyle = .round
                path.close()

                let shapeLayer = CAShapeLayer()
                shapeLayer.shadowOffset = .zero
                shapeLayer.shadowRadius = 10
                shapeLayer.shadowColor = UIColor.red.cgColor
                shapeLayer.shadowOpacity = 2.0

                shapeLayer.path = path.cgPath
                shapeLayer.lineWidth = path.lineWidth
                shapeLayer.fillColor = UIColor.systemYellow.cgColor

                shapeLayer.strokeColor = UIColor.systemYellow.cgColor
                starView.layer.addSublayer(shapeLayer)
            }
        }
        return starView.asImage()
    }
}
