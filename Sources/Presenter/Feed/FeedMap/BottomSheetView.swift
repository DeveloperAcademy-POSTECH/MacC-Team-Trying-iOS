//
//  BottomSheetView.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import SnapKit
import UIKit

final class BottomSheetView: PassThroughView {
    // MARK: Constants
    enum Mode {
        case tip
        case full
    }
    private enum BottomViewConst {
        static let duration = 0.5
        static let cornerRadius = 12.0
        static let barViewTopSpacing = 5.0
        static let barViewSize = CGSize(width: DeviceInfo.screenWidth * 0.2, height: 5.0)
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
            case .tip:
                return 0.9 // 위에서 부터의 값 (밑으로 갈수록 값이 커짐)
            case .full:
                return 0.65
            }
        }
        static let bottomSheetYPosition: (Mode) -> Double = { mode in
            Self.bottomSheetRatio(mode) * DeviceInfo.screenHeight
        }
    }

    // MARK: UI
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(Palette.black)
        return view
    }()

    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.isUserInteractionEnabled = false
        return view
    }()

    // MARK: Properties
    var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            self.updateConstraint(offset: BottomViewConst.bottomSheetYPosition(self.mode))
        }
    }

    var bottomSheetColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetColor }
    }

    var barViewColor: UIColor? {
        didSet { self.barView.backgroundColor = self.barViewColor }
    }

    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGesture)

        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = BottomViewConst.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        self.addSubview(self.bottomSheetView)
        self.bottomSheetView.addSubview(self.barView)

        self.bottomSheetView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(BottomViewConst.bottomSheetYPosition(.tip))
        }

        self.barView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(BottomViewConst.barViewTopSpacing)
            make.size.equalTo(BottomViewConst.barViewSize)
        }
    }

    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: self).y
        let minY = self.bottomSheetView.frame.minY
        let offset = translationY + minY

        if BottomViewConst.bottomSheetYPosition(.full)...BottomViewConst.bottomSheetYPosition(.tip) ~= offset {
            self.updateConstraint(offset: offset)
            recognizer.setTranslation(.zero, in: self)
        }
        UIView.animate(
            withDuration: 0,
            delay: 0,
            options: .curveEaseOut,
            animations: self.layoutIfNeeded,
            completion: nil
        )

        guard recognizer.state == .ended else { return }
        UIView.animate(
            withDuration: BottomViewConst.duration,
            delay: 0,
            options: .allowUserInteraction,
            animations: {
                // velocity를 통해 위인지 아래인지.
                self.mode = recognizer.velocity(in: self).y >= 0 ? Mode.tip : .full
            },
            completion: nil
        )
    }

    private func updateConstraint(offset: Double) {
        self.bottomSheetView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(offset)
        }
    }
}

class PassThroughView: UIView {
    /// superview가 터치 이벤트를 받을 수 있도록,
    /// 해당 뷰 (subview)가 터치되면 nil을 반환하고 다른 뷰일경우 UIView를 반환
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
}
