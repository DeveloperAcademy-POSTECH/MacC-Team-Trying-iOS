//
//  LogCollectionViewCell.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import CoreLocation

import SnapKit
import Lottie

class LogCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LogCollectionViewCell"
    
    let courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._15)
        label.tintColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.designSystem(weight: .regular, size: ._13)
        label.tintColor = UIColor.designSystem(.grayC5C5C5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogCollectionViewCell {
    
    func configure(with places: [PlaceEntity]) {
        self.contentView.subviews
            .filter { view in
                return !(view == dateLabel || view == courseNameLabel)
            }
            .forEach { $0.removeFromSuperview() }
        
        let courseView = makeConstellation(places: places)
        contentView.addSubview(courseView)
        courseView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    private func setConstraints() {
        contentView.addSubviews(
            courseNameLabel,
            dateLabel
        )
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.5)
        }
        
        courseNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(dateLabel.snp.top).offset(-5)
        }
    }
    
    func makeConstellation(places: [PlaceEntity]) -> UIView {
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
}
