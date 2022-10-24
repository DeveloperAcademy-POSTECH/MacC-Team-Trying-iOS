//
//  PlanetCollectionViewCell.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class PlanetCollectionViewCell: UICollectionViewCell {

    lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with planetName: String) {
        imageView.image = UIImage(named: planetName)
    }
}
