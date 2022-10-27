//
//  ConstellationCollectionViewCell.swift
//  MatStar
//
//  Created by uiskim on 2022/10/13.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

//class ConstellationCollectionViewCell: UICollectionViewCell {
//    
//    var constellation: Constellation? {
//        didSet {
//            guard let constellation = constellation else { return }
//            mainTitle.text = constellation.name
//            constellationImage.image = constellation.image
//            mainTitle.snp.makeConstraints { make in
//                make.top.equalTo(constellationImage.snp.bottom).offset(10)
//                make.height.equalTo(26)
//                make.width.equalTo((constellation.name as NSString).size().width + 50)
//            }
//        }
//    }
//    
//    static let identifier = "ConstellationCollectionViewCell"
//    
//    var constellationImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    
//    var mainTitle: UILabel = {
//        let title = UILabel()
//        title.clipsToBounds = true
//        title.backgroundColor = .black
//        title.textColor = .designSystem(.mainYellow)
//        title.textAlignment = .center
//        title.layer.cornerRadius = 13
//        title.layer.borderColor = .designSystem(.mainYellow)
//        title.layer.borderWidth = 1
//        title.font = .designSystem(weight: .bold, size: ._15)
//        return title
//    }()
//    
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [constellationImage, mainTitle])
//        stackView.spacing = 5
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        return stackView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
