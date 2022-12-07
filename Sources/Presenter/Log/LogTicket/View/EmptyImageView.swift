//
//  EmptyImageView.swift
//  우주라이크
//
//  Created by YeongJin Jeong on 2022/12/04.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class EmptyImageView: UIView {
    
    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alarmHeart")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emptyImageViewTextLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .regular, size: ._15)
        label.text = "등록된 사진이 없어요!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyImageView {
    private func setUI() {
        addSubview(heartImageView)
        addSubview(emptyImageViewTextLabel)
        
        heartImageView.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 100 / 390)
            make.height.equalTo(DeviceInfo.screenHeight * 85 / 844)
            make.center.equalToSuperview()
        }
        
        emptyImageViewTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(heartImageView.snp.bottom).offset(30)
        }
    }
}
