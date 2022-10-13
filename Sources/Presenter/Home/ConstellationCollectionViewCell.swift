//
//  ConstellationCollectionViewCell.swift
//  MatStar
//
//  Created by uiskim on 2022/10/13.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class ConstellationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ConstellationCollectionViewCell"
    
    var constellationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .blue
        addSubview(constellationImage)
//        constellationImage.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.size.equalTo(100)
//        }
        constellationImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
