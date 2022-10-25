//
//  CarouselCell.swift
//  MatStar
//
//  Created by uiskim on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class CarouselCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    static let cellId = "CarouselCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(80)
            make.height.equalTo(200)
        }
    }
}

extension CarouselCollectionViewCell {
    public func configure(image: UIImage?, text: String) {
        imageView.image = image
    }
}
