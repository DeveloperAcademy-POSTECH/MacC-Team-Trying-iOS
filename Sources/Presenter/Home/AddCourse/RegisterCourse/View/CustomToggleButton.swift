//
//  CustomToggleButton.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class CustomToggleButton: UIButton {
    typealias SwitchColor = (bar: UIColor, circle: UIColor)
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray252632)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    private lazy var closedLockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Image.closedLockIcon)?.withTintColor(.designSystem(.gray3B3C46)!)
        imageView.tintColor = .blue
        return imageView
    }()
    private lazy var openLockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Image.openLockIcon)?.withTintColor(.designSystem(.mainYellow)!)
        return imageView
    }()
    var isOn: Bool = true {
        didSet {
            self.changeState()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn.toggle()
    }
    
    private func setLayout() {
        addSubviews(barView, circleView, closedLockImageView, openLockImageView)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        barView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(58)
            make.height.equalTo(22)
        }
        
        circleView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        closedLockImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        openLockImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(9)
        }
    }
    
    private func changeState() {
        if isOn {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.circleView.center.x = self.frame.width - (self.circleView.frame.width / 2)
                }
                
                UIView.animate(withDuration: 0.4) { [weak self] in
                    guard let self = self else { return }
                    self.closedLockImageView.image = UIImage(named: Constants.Image.closedLockIcon)?.withTintColor(.designSystem(.gray3B3C46)!)
                    self.openLockImageView.image = UIImage(named: Constants.Image.openLockIcon)?.withTintColor(.designSystem(.mainYellow)!)
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    guard let self = self else { return }
                    self.circleView.center.x = self.circleView.frame.width / 2
                }
                
                UIView.animate(withDuration: 0.4) { [weak self] in
                    guard let self = self else { return }
                    self.closedLockImageView.image = UIImage(named: Constants.Image.closedLockIcon)?.withTintColor(.designSystem(.mainYellow)!)
                    self.openLockImageView.image = UIImage(named: Constants.Image.openLockIcon)?.withTintColor(.designSystem(.gray3B3C46)!)
                }
            }
        }
    }
}
