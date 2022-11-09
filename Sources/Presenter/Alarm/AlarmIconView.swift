//
//  alarmIcon.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/08.
//

import Foundation
import UIKit
import SnapKit

class AlarmIconView: UIView {
    
    var iconImageString: String? {
        didSet {
            guard let iconImageString = iconImageString else { return }
            imageView.image = UIImage(named: iconImageString)
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    convenience init() {
        self.init(frame: .zero)
        setUI()
    }
    
    private func setUI() {
        
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        backgroundColor = .white.withAlphaComponent(0.2)
        addSubview(imageView)

        snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }

//        backgroundColor = .brown
        
    }
    
}
