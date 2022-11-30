//
//  SplashViewController.swift
//  우주라이크
//
//  Created by 김승창 on 2022/11/30.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import Lottie
import SnapKit

final class SplashViewController: UIViewController {
    var viewModel: SplashViewModel
    
    private lazy var lottieView: LottieAnimationView = {
        let view = LottieAnimationView(name: "splash")
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 2.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension SplashViewController {
    private func setUI() {
        self.setLottie()
        self.setLayout()
    }
    
    private func setLottie() {
        lottieView.play { _ in
            self.viewModel.startAppCoordinator()
        }
    }
    
    private func setLayout() {
        view.addSubview(lottieView)
        
        lottieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
