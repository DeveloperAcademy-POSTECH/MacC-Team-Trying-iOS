//
//  PlaceDetailView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import MapKit
import UIKit

import SnapKit

final class PlaceDetailView: UIView {
    var selectedPlace: CLPlacemark? {
        didSet {
            guard let selectedPlace = selectedPlace else { return }
            let name = selectedPlace.name ?? ""
            // TODO: 카테고리로 수정하기
            let category = selectedPlace.country ?? ""
            let administrativeArea = selectedPlace.administrativeArea ?? ""
            let locality = selectedPlace.locality ?? ""
            let thoroughfare = selectedPlace.thoroughfare ?? ""
            let subThoroughfare = selectedPlace.subThoroughfare ?? ""
            let address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
            
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
    private lazy var placeInfoContrainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        return view
    }()
    private lazy var placeInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "위치 정보"
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.white)
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "영업시간"
        label.font = .designSystem(weight: .regular, size: ._13)
        label.textColor = .designSystem(.white)
        return label
    }()
    private lazy var holidayLabel: UILabel = {
        let label = UILabel()
        label.text = "휴무일"
        label.font = .designSystem(weight: .regular, size: ._13)
        label.textColor = .designSystem(.white)
        return label
    }()
    private lazy var placeTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 10:00 ~ 23:00"
        label.font = .designSystem(weight: .bold, size: ._13)
        label.textColor = .designSystem(.mainYellow)
        return label
    }()
    private lazy var placeHolidayLabel: UILabel = {
        let label = UILabel()
        label.text = "매주 월요일"
        label.font = .designSystem(weight: .bold, size: ._13)
        label.textColor = .designSystem(.mainYellow)
        return label
    }()
    
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
        
        placeInfoView.addSubviews(
            titleLabel,
            categoryLabel,
            addressLabel
        )
        placeInfoContrainerView.addSubviews(
            placeInformationLabel,
            timeLabel,
            holidayLabel,
            placeTimeLabel,
            placeHolidayLabel
        )
        self.addSubviews(placeInfoView, addCourseButton, placeInfoContrainerView)
        
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
        
        placeInfoContrainerView.snp.makeConstraints { make in
            make.top.equalTo(placeInfoView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        placeInformationLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(placeInformationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        holidayLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        placeTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(20)
            make.centerY.equalTo(timeLabel)
        }
        
        placeHolidayLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeTimeLabel.snp.leading)
            make.centerY.equalTo(holidayLabel)
        }
    }
}
