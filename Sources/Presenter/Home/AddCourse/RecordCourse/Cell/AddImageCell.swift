//
//  AddImageCell.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class AddImageCell: UICollectionViewCell {
    static let identifier = "AddImageCellIdentifier"
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .designSystem(.gray252632)
        button.setImage(UIImage(systemName: Constants.Image.photoIcon), for: .normal)
        button.tintColor = .designSystem(.white)
        
        if #available(iOS 15.0, *) {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18)
            var buttonConfiguration = UIButton.Configuration.plain()
            buttonConfiguration.preferredSymbolConfigurationForImage = imageConfiguration
            button.configuration = buttonConfiguration
        }
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(addImageButton)
        
        addImageButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
