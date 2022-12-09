//
//  PlanCompleteViewController.swift
//  우주라이크
//
//  Created by 김승창 on 2022/12/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import CoreMotion
import Foundation
import UIKit

import CancelBag
import Lottie
import SnapKit

final class PlanCompleteViewController: BaseViewController {
    var viewModel: PlanCompleteViewModel
    
    private lazy var mediumStarBackgroundView = MediumStarBackgroundView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.width + 30,
            height: view.frame.height + 30
        )
    )
    private lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString()
        let firstString = NSAttributedString(string: "새로운 별자리가", attributes: [.font: UIFont.gmarksans(weight: .light, size: ._15)])
        var labelString = "\n계획"
        let secondString = NSAttributedString(string: labelString, attributes: [.font: UIFont.gmarksans(weight: .bold, size: ._15)])
        let thirdString = NSAttributedString(string: "됐습니다!", attributes: [.font: UIFont.gmarksans(weight: .medium, size: ._15)])
        attributedString.append(firstString)
        attributedString.append(secondString)
        attributedString.append(thirdString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    private lazy var starLottie: LottieAnimationView = {
        let lottie = LottieAnimationView(name: Constants.Lottie.starLottie)
        lottie.contentMode = .scaleAspectFit
        lottie.animationSpeed = 0.5
        lottie.loopMode = .loop
        lottie.play()
        return lottie
    }()
    private lazy var doneButton: MainButton = {
        let button = MainButton(type: .home)
        button.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: PlanCompleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - UI
extension PlanCompleteViewController {
    private func setUI() {
        setGyroMotion()
        self.setPlanCompleteViewLayout()
    }
    
    /// PlanComplete 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setPlanCompleteViewLayout() {
        view.addSubviews(
            completeLabel,
            starLottie,
            doneButton
        )
        
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(180)
            make.centerX.equalToSuperview()
        }
        
        starLottie.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(105)
            make.height.equalTo(170)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setGyroMotion() {
        motionManager = CMMotionManager()
        
        motionManager?.gyroUpdateInterval = 0.01
        motionManager?.startGyroUpdates(to: .main, withHandler: { [weak self] data, _ in
            guard let self = self,
                  let data = data else { return }
            
            let offsetRate = 0.2
            self.lastXOffset += data.rotationRate.x * offsetRate
            self.lastYOffset += data.rotationRate.y * offsetRate
            
            let backgroundOffsetRate = 0.3
            let mediumStarBackgroundOffsetRate = 1.0
            let constellationOffsetRate = 2.0
            
            if abs(self.lastYOffset) < 50 {
                self.backgroundView.center.x = DeviceInfo.screenWidth / 2 + self.lastYOffset * backgroundOffsetRate
                self.mediumStarBackgroundView.center.x = DeviceInfo.screenWidth / 2 + self.lastYOffset * mediumStarBackgroundOffsetRate
            }
            
            if abs(self.lastXOffset) < 50 {
                self.backgroundView.center.y = DeviceInfo.screenHeight / 2 + self.lastXOffset * backgroundOffsetRate
                self.mediumStarBackgroundView.center.y = DeviceInfo.screenHeight / 2 + self.lastXOffset * mediumStarBackgroundOffsetRate
            }
        })
    }
}

// MARK: - User Interactions
extension PlanCompleteViewController {
    @objc
    private func didTapDoneButton(_ sender: UIButton) {
        viewModel.popToHomeView()
    }
}
