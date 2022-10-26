//
//  AddCourseCompleteViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

protocol HomeCoordinating {
    func popToHomeViewController()
}

final class AddCourseCompleteViewModel: BaseViewModel {
    var coordinator: Coordinator
    var places: [Place]
    
    init(
        coordinator: Coordinator,
        places: [Place]
    ) {
        self.coordinator = coordinator
        self.places = places
    }

    func makeStars(stars: [Place]) -> UIImage? {
        let starView = UIView()
        starView.backgroundColor = .black
        starView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)

        let latitudeArray = stars.map { CGFloat($0.location.latitude) }
        let longtitudeArray = stars.map { CGFloat($0.location.longitude) }

        let minX = latitudeArray.min()!
        let maxX = latitudeArray.max()!
        let minY = longtitudeArray.min()!
        let maxY = longtitudeArray.max()!

        let deltaX = maxX - minX
        let deltaY = maxY - minY

        let adjustedLatitude = latitudeArray.map{(CGFloat(($0 - minX) / deltaX ) * 150) * 0.8}
        let adjustedLongtitude = longtitudeArray.map{(CGFloat(($0 - minY) / deltaY) * 150) * 0.8}

        for index in stars.indices {
            let imageView = UIImageView()
            let image = UIImage(named: "star")
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.frame = CGRect(x: adjustedLatitude[index], y: adjustedLongtitude[index], width: 25, height: 25)
            imageView.layer.shadowOffset = .zero
            imageView.layer.shadowRadius = 10
            imageView.layer.shadowColor = UIColor.red.cgColor
            imageView.layer.shadowOpacity = 2.0

            starView.addSubview(imageView)

            if index < stars.count - 1 {
                let xPan = (adjustedLatitude[index + 1] - adjustedLatitude[index])
                let yPan = (adjustedLongtitude[index + 1] - adjustedLongtitude[index])

                let distance = ((xPan * xPan) + (yPan * yPan)).squareRoot()
                let editX = 13 / distance * xPan
                let editY = 13 / distance * yPan

                let path = UIBezierPath()
                path.move(to: CGPoint(x: adjustedLatitude[index] + imageView.frame.size.width / 2 + editX, y: adjustedLongtitude[index] + imageView.frame.size.height / 2 + editY))
                path.addLine(to: CGPoint(x: adjustedLatitude[index + 1] + imageView.frame.size.width / 2 - editX, y: adjustedLongtitude[index + 1] + imageView.frame.size.height / 2 - editY))
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

// MARK: - Coordinating
extension AddCourseCompleteViewModel {
    func popToHomeView() {
        guard let coordinator = coordinator as? HomeCoordinating else { return }
        coordinator.popToHomeViewController()
    }
}
