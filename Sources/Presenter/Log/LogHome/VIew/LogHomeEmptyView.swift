//
//  LogHomeEmptyVIew.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class LogHomeEmptyView: UIView {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alarmHeart")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogHomeEmptyView {
    private func setUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
}
