//
//  CarouselCell.swift
//  MatStar
//
//  Created by uiskim on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class CarouselCell: UICollectionViewCell {
    var imageView = UIImageView()
    var constellationImage = UIImageView()
    static let cellId = "CarouselCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        backgroundColor = .clear
        constellationImage.contentMode = .scaleAspectFit
        
        addSubview(imageView)
        imageView.addSubview(constellationImage)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        constellationImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(80)
        }
    }
}

extension CarouselCell {
    public func configure(image: UIImage?, text: String) {
        constellationImage.image = image
    }
}
