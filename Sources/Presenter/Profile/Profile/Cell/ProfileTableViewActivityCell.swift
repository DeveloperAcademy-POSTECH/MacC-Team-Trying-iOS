//
//  ProfileTableViewActivityCell.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

final class ProfileTableViewActivityCell: UITableViewCell {
    static let identifier = "ProfileTableViewActivityCellIdentifier"
    
    lazy var constellationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let myConstellationLabel: UILabel = {
        let label = UILabel()
        label.text = "내 별자리"
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    lazy var numberOfConstellationLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._20)
        label.textColor = .designSystem(.mainYellow)
        return label
    }()
    
    /*
    lazy var likeCourseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let courseLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아하는 코스"
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    lazy var numberOfLikedCourseLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._20)
        label.textColor = .designSystem(.mainYellow)
        return label
    }()
     */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10
        
        self.constellationStackView.addArrangedSubview(myConstellationLabel)
        self.constellationStackView.addArrangedSubview(numberOfConstellationLabel)
        
        // self.likeCourseStackView.addArrangedSubview(courseLabel)
        // self.likeCourseStackView.addArrangedSubview(numberOfLikedCourseLabel)
        
        self.contentView.addSubviews(
            constellationStackView
            // likeCourseStackView
        )
        
        constellationStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        /*
        likeCourseStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(50)
        }
         */
    }
}
