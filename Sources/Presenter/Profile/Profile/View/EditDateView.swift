//
//  EditDateView.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

final class EditDateView: UIView {
    var height: CGFloat = 500
    
    private let blurBackgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.layer.backgroundColor = UIColor.designSystem(.pinkF09BA1)?.withAlphaComponent(0.8).cgColor
        view.layer.opacity = 0.8
        return view
    }()
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .designSystem(.white)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Image.editDateImage)
        return imageView
    }()
    
    private let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "변경하실 일자를 선택해주세요!"
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._13)
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
        button.setTitleColor(.designSystem(.black), for: .normal)
        button.backgroundColor = .designSystem(.mainYellow)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension EditDateView {
    private func setUI() {
        self.layer.cornerRadius = 15
        self.backgroundColor = .brown
        self.addSubviews(
//            blurBackgroundView,
            dismissButton,
            imageView,
            viewLabel,
            datePicker,
            doneButton
        )
        
//        blurBackgroundView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        dismissButton.snp.makeConstraints { make in
            make.top
                .trailing.equalToSuperview().inset(20)
            make.width
                .height.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        viewLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview().inset(20)
            make.top.equalTo(viewLabel.snp.bottom).offset(50)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading
                .trailing
                .bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

// MARK: - BottomHidable
extension EditDateView: BottomHidable {
    func hide() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(-height)
        }
    }
    
    func present() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(180)
        }
    }
}
