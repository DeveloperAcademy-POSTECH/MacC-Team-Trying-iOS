//
//  CourseImageCollectionViewCell.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class CourseImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CourseImageCollectionViewCell"
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
