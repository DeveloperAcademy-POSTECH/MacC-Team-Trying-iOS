//
//  CourseCompleteViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import CoreMotion
import UIKit

import CancelBag
import Lottie
import SnapKit

final class CourseCompleteViewController: BaseViewController {
    var viewModel: CourseCompleteViewModel
    
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
        var labelString = "\n기록"
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
    private lazy var constellationView: UIView = {
        let view = self.makeConstellation(places: viewModel.courseRequestDTO.places)
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return view
    }()
    private lazy var courseTitleLabel: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
        label.textColor = .designSystem(.mainYellow)
        label.font = .designSystem(weight: .bold, size: ._13)
        label.backgroundColor = .designSystem(.black)
        label.layer.borderColor = .designSystem(.mainYellow)
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 12.5
        return label
    }()
    private lazy var doneButton: MainButton = {
        let button = MainButton(type: .home)
        button.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        self.courseTitleLabel.text = self.viewModel.courseRequestDTO.title
    }
    
    init(viewModel: CourseCompleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
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
extension CourseCompleteViewController {
    private func setUI() {
        setGyroMotion()
        self.setRecordCompleteViewLayout()
    }
    
    /// RecordComplete 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setRecordCompleteViewLayout() {
        view.addSubviews(
            mediumStarBackgroundView,
            completeLabel,
            constellationView,
            courseTitleLabel,
            doneButton
        )
        
        completeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        courseTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(doneButton.snp.top).offset(-100)
            make.height.equalTo(25)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func makeConstellation(places: [Place]) -> UIView {
        let constellationView = UIView()
        constellationView.backgroundColor = .clear
        constellationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        let latitudeArray = places.map { CGFloat($0.location.latitude) }
        let longitudeArray = places.map { CGFloat($0.location.longitude) }
        
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
                self.constellationView.center.x = DeviceInfo.screenWidth / 2 - self.lastYOffset * constellationOffsetRate
            }
            
            if abs(self.lastXOffset) < 50 {
                self.backgroundView.center.y = DeviceInfo.screenHeight / 2 + self.lastXOffset * backgroundOffsetRate
                self.mediumStarBackgroundView.center.y = DeviceInfo.screenHeight / 2 + self.lastXOffset * mediumStarBackgroundOffsetRate
                self.constellationView.center.y = (DeviceInfo.screenHeight / 2) - (self.lastXOffset * constellationOffsetRate)
            }
        })
    }
}

// MARK: - User Interactions
extension CourseCompleteViewController {
    @objc
    private func didTapDoneButton(_ sender: UIButton) {
        viewModel.popToHomeView()
    }
}
