//
//  MediumStarBackgroundView.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import Lottie

final class MediumStarBackgroundView: UIView {
    private let numberOfStar = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        for _ in 0..<numberOfStar {
            let starLottie = LottieAnimationView(name: Constants.Lottie.middleStar)
            starLottie.frame = .init(origin: generateRandomPosition(), size: generateRandomSize())
            starLottie.contentMode = .scaleAspectFit
            starLottie.animationSpeed = CGFloat.random(in: 0.05...0.1)
            starLottie.loopMode = .loop
            starLottie.play()
            
            self.addSubview(starLottie)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateRandomPosition() -> CGPoint {
        let width = frame.width
        let height = frame.height
        
        return CGPoint(
            x: CGFloat(UInt32.random(in: 0...UInt32.max)).truncatingRemainder(dividingBy: width),
            y: CGFloat(UInt32.random(in: 0...UInt32.max)).truncatingRemainder(dividingBy: height)
        )
    }
    
    private func generateRandomSize() -> CGSize {
        let randomSize = Double.random(in: 20.0...35.0)
        return CGSize(width: randomSize, height: randomSize)
    }
}
