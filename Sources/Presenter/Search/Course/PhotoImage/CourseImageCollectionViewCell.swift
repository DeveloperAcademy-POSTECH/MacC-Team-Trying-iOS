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
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        contentView.addSubview(photoImageView)
        photoImageView.backgroundColor = .brown
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(113)
            make.height.equalTo(169)
        }
    }
}
