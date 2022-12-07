//
//  LogImageCollectionViewCell.swift
//  우주라이크
//
//  Created by YeongJin Jeong on 2022/12/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

class LogImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LogImageCollectionViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogImageCollectionViewCell {
    
    func configure(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        imageView.contentMode = .scaleToFill
        imageView.load(url: url)
    }
    
    private func setConstraints() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
