//
//  AddPlaceDetailView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import MapKit
import UIKit

import SnapKit

final class AddPlaceDetailView: UIView {
	var height: CGFloat = 190

    var selectedPlace: Place? {
        didSet {
            guard let selectedPlace = selectedPlace else { return }
            let name = selectedPlace.title
            let category = selectedPlace.category
            let address = selectedPlace.address
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.titleLabel.text = name
                self.categoryLabel.text = category
                self.addressLabel.text = address
            }
        }
    }
    private lazy var placeInfoView = UIView()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.grayC5C5C5)
        label.font = .designSystem(weight: .regular, size: ._11)
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.grayC5C5C5)
        label.font = .designSystem(weight: .regular, size: ._13)
        return label
    }()
    lazy var addCourseButton = SmallRectButton(type: .add)
    lazy var memoTextField = CustomTextField(type: .memo)
    
    init() {
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .designSystem(.black)
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
        
        placeInfoView.addSubviews(
            titleLabel,
            categoryLabel,
            addressLabel
        )
        
        self.addSubviews(
            placeInfoView,
            addCourseButton,
            memoTextField
        )
        
        placeInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(33)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.bottom.equalTo(titleLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview()
        }
        
        addCourseButton.snp.makeConstraints { make in
            make.centerY.equalTo(placeInfoView)
            make.trailing.equalToSuperview().inset(20)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(placeInfoView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - BottomHidable
extension AddPlaceDetailView: BottomHidable {
    func hide() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(-height)
        }
    }
    
    func present() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
}
