//
//  LogTicketEmptyView.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//
import Foundation

import UIKit
import SnapKit

class LogTicketEmptyView: UIView {
    
    var rootViewState = RootViewState.LogHome
    
    private let viewModel: LogTicketViewModel
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark))
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 15
        return blurEffectView
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let configure = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configure), for: .normal)
        button.tintColor = .designSystem(.white)
        return button
    }()
    
    lazy var flopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        return button
    }()
    
    private let heartImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "alarmHeart")
        return view
    }()
    
    let logTicketEmptyViewLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._15)
        label.text = "나의 후기가 없어요! 작성해주세요!"
        return label
    }()
    
    let addCourseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .designSystem(.mainYellow)
        button.setTitle("후기 등록", for: .normal)
        button.setTitleColor(.designSystem(.black), for: .normal)
        button.titleLabel?.font = .gmarksans(weight: .bold, size: ._15)
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: Initializer
    init(viewModel: LogTicketViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setLayouts()
        setButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        drawTicket()
    }
}

extension LogTicketEmptyView {
    // Snapkit을 사용해 Component의 Layout을 배치합니다.
    private func setLayouts() {
        self.addSubviews(
            flopButton,
            heartImageView,
            logTicketEmptyViewLabel,
            addCourseButton,
            blurEffectView,
            dismissButton
        )
        
        self.sendSubviewToBack(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        heartImageView.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 100 / 390)
            make.height.equalTo(DeviceInfo.screenHeight * 85 / 844)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(DeviceInfo.screenHeight * 146 / 844)
        }
        
        flopButton.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.06153846154)
            make.height.equalTo(DeviceInfo.screenHeight * 0.02843601896)
            make.right.equalToSuperview().offset(-DeviceInfo.screenWidth * 0.05128205128)
            make.bottom.equalToSuperview().offset(-DeviceInfo.screenHeight * 0.02369668246)
        }
        
        logTicketEmptyViewLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(heartImageView.snp.bottom).offset(30)
        }
        
        addCourseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(DeviceInfo.screenHeight * 20 / 844)
            make.width.equalTo(DeviceInfo.screenWidth * 310 / 390)
            make.height.equalTo(DeviceInfo.screenHeight * 58 / 844)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(DeviceInfo.screenWidth * 20 / 390)
            make.top.equalToSuperview().inset(DeviceInfo.screenHeight * 20 / 844)
            make.width.equalTo(DeviceInfo.screenWidth * 22 / 390)
            make.height.equalTo(DeviceInfo.screenHeight * 24 / 844)
        }
    }
    
    // MARK: Ticket Drawing
    private func drawTicket() {
        layer.cornerRadius = 18
        switch rootViewState {
        case .LogHome:
            backgroundColor = .designSystem(.pinkEB97D9)?.withAlphaComponent(0.4)
        case .LogMap:
            backgroundColor = .designSystem(.black)?.withAlphaComponent(0.75)
        }
        
        let radious = DeviceInfo.screenWidth * 0.1282051282 / 2
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
        let ticketShapePath = UIBezierPath(roundedRect: ticketShapeLayer.bounds, cornerRadius: radious)
        let bottomRightArcPath = UIBezierPath(
            arcCenter: CGPoint(
                x: ticketShapeLayer.frame.width,
                y: DeviceInfo.screenHeight * 0.5106635071
            ),
            radius: radious,
            startAngle: CGFloat( Double.pi / 2 ),
            endAngle: CGFloat(Double.pi + Double.pi / 2),
            clockwise: true
        )
        bottomRightArcPath.close()
        
        let bottomLeftArcPath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: DeviceInfo.screenHeight * 0.5106635071),
            radius: radious,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi / 2 + Double.pi),
            clockwise: false
        )
        bottomRightArcPath.close()
        
        let lineShapeLayer = CAShapeLayer()
        lineShapeLayer.strokeColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        lineShapeLayer.lineWidth = 3
        lineShapeLayer.lineDashPattern = [5, 5]
        
        let path = CGMutablePath()
        path.addLines(
            between: [
                CGPoint(x: 18, y: DeviceInfo.screenHeight * 0.5106635071),
                CGPoint(x: ticketShapeLayer.bounds.size.width - 18, y: DeviceInfo.screenHeight * 0.5106635071)
            ]
        )
        lineShapeLayer.path = path
        ticketShapePath.append(bottomLeftArcPath)
        ticketShapePath.append(bottomRightArcPath.reversing())
        ticketShapeLayer.path = ticketShapePath.cgPath
        layer.addSublayer(lineShapeLayer)
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
        layer.mask = ticketShapeLayer
        
    }
    
    // MARK: Blur Effect 추가
    private func setBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let outerVisualEffectView = UIVisualEffectView(effect: blurEffect)
        
        switch rootViewState {
        case .LogHome:
            outerVisualEffectView.layer.backgroundColor = UIColor.designSystem(.pinkF09BA1)?.withAlphaComponent(0.5).cgColor
        case .LogMap:
            outerVisualEffectView.layer.backgroundColor = UIColor.designSystem(.black)?.withAlphaComponent(0.75).cgColor
        }
        
        outerVisualEffectView.layer.opacity = 0.5
        outerVisualEffectView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight)
        self.addSubview(outerVisualEffectView)
        self.sendSubviewToBack(outerVisualEffectView)
    }
    
    private func setButtonTarget() {
        dismissButton.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
    }
    
    @objc
    func tapDismissButton() {
        viewModel.tapDismissButton()
    }
}
