//
//  BaseViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/11.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import CoreMotion
import UIKit

import CancelBag
import SnapKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    let cancelBag = CancelBag()
    
    private var lastXOffset: CGFloat = 0
    private var lastYOffset: CGFloat = 0
    private lazy var backgroundView = BackgroundView(frame: CGRect(x: 0, y: 0, width: view.frame.width + 30, height: view.frame.height + 30))

    private var motionManager: CMMotionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        setGyroMotionManager()
        // view.backgroundColor = .designSystem(.black)                                // 화면 배경 색상을 설정합니다.
        navigationController?.interactivePopGestureRecognizer?.delegate = self      // Swipe-gesture를 통해 pop을 합니다.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        motionManager?.stopGyroUpdates()
    }
    
    private func setGyroMotionManager() {
        motionManager = CMMotionManager()
        
        motionManager?.gyroUpdateInterval = 0.01
        motionManager?.startGyroUpdates(to: .main, withHandler: { [weak self] data, _ in
            guard let self = self,
                  let data = data else { return }
            
            let offsetRate = 0.2
            self.lastXOffset += data.rotationRate.x * offsetRate
            self.lastYOffset += data.rotationRate.y * offsetRate

            self.backgroundView.center = CGPoint(x: DeviceInfo.screenWidth / 2 + self.lastYOffset, y: DeviceInfo.screenHeight / 2 + self.lastXOffset)
        })
    }
}
