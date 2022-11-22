//
//  StarMaker.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit
import Lottie

struct StarMaker {
    
    static func makeConstellation(places: [PlaceEntity]) -> UIView {
        let constellationView = UIView()
        constellationView.backgroundColor = .clear
        constellationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        let latitudeArray = places.map { CGFloat($0.coordinate.latitude) }
        let longitudeArray = places.map { CGFloat($0.coordinate.longitude) }
        
        guard let minX = latitudeArray.min(),
              let maxX = latitudeArray.max(),
              let minY = longitudeArray.min(),
              let maxY = longitudeArray.max() else { return UIView() }
        
        let deltaX: CGFloat = maxX == minX ? 1 : maxX - minX
        let deltaY: CGFloat = maxY == minY ? 1 : maxY - minY
        
        let adjustedLatitude = latitudeArray.map { (CGFloat(($0 - minX) / deltaX ) * 200) * 0.8 }
        let adjustedLongitude = longitudeArray.map { (CGFloat(($0 - minY) / deltaY) * 200) * 0.8 }
        
        let xOffset = (200 - abs(adjustedLatitude.max()!)) / 2 - 12.5
        let yOffset = (200 - abs(adjustedLongitude.max()!)) / 2 - 12.5
        
        for index in places.indices {
            let randomStarLottieSize = CGFloat.random(in: (30.0...60.0))
            let starLottie = LottieAnimationView(name: Constants.Lottie.mainStar)
            starLottie.contentMode = .scaleAspectFit
            starLottie.frame = CGRect(x: adjustedLatitude[index] + xOffset, y: adjustedLongitude[index] + yOffset, width: randomStarLottieSize, height: randomStarLottieSize)
            starLottie.animationSpeed = CGFloat.random(in: 0.05...0.3)
            starLottie.animationSpeed = 0.6
            starLottie.loopMode = .loop
            starLottie.play(fromProgress: 0.0, toProgress: 0.9935)
            
            constellationView.addSubview(starLottie)
            
            if index < places.count - 1 {
                let xPan = (adjustedLatitude[index + 1] - adjustedLatitude[index])
                let yPan = (adjustedLongitude[index + 1] - adjustedLongitude[index])
                
                let distance = ((xPan * xPan) + (yPan * yPan)).squareRoot()
                let editX = 13 / distance * xPan
                let editY = 13 / distance * yPan
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: adjustedLatitude[index] + starLottie.frame.size.width / 2 + editX + xOffset, y: adjustedLongitude[index] + starLottie.frame.size.height / 2 + editY + yOffset))
                path.addLine(to: CGPoint(x: adjustedLatitude[index + 1] + starLottie.frame.size.width / 2 - editX + xOffset, y: adjustedLongitude[index + 1] + starLottie.frame.size.height / 2 - editY + yOffset))
                path.lineWidth = 0.15
                path.close()
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.lineWidth = path.lineWidth
                shapeLayer.strokeColor = .designSystem(.whiteFFFBD9)
                constellationView.layer.addSublayer(shapeLayer)
            }
        }
        return constellationView
    }
    
    static func makeStars(places: [PlaceEntity]) -> UIImage? {
        let starView = UIView()
        starView.backgroundColor = .clear
        starView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        let latitudeArray = places.map { CGFloat($0.coordinate.latitude) }
        let longtitudeArray = places.map { CGFloat($0.coordinate.longitude) }

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
            imageView.frame = CGRect(x: adjustedLatitude[index] + xOffset, y: adjustedLongtitude[index] + yOffset, width: 50, height: 50)
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
                path.lineWidth = 5
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
