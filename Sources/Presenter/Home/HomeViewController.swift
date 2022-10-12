//
//  HomeViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class HomeViewController: BaseViewController {
    
    var viewModel: HomeViewModel?
    
    let myProfileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.backgroundColor = .red
        return image
    }()
    
    let otherProfileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.backgroundColor = .blue
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.text = String.makeAtrributedString(name: "카리나", appendString: "와 함께", changeAppendStringSize: 15, changeAppendStringWieght: .regular)
        return label
    }()
    
    private let ddayLabel: UILabel = {
        let label = UILabel()
        label.text = "D+273"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ddayLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: viewModel?.isSolo ?? true ? [myProfileImage, otherProfileImage] : [myProfileImage])
        stackView.spacing = -10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .yellow
        return stackView
    }()
    
    private let alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "flame.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }


    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
}

// MARK: - UI
extension HomeViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
        view.backgroundColor = UIColor(named: "MainBlack")
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        view.addSubview(labelStackView)
        view.addSubview(profileStackView)
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        myProfileImage.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        otherProfileImage.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        profileStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(60)
            make.height.equalTo(50)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.left.equalTo(profileStackView.snp.right).offset(10)
            make.height.equalTo(50)
            make.centerY.equalTo(profileStackView.snp.centerY)
        }
    }
}

extension String {
    static func makeAtrributedString(name: String, appendString: String, changeAppendStringSize: CGFloat, changeAppendStringWieght: UIFont.Weight) -> NSMutableAttributedString {
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        let profileString = name + appendString
        print(profileString)
        let attributedQuote = NSMutableAttributedString(string: profileString)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor.red, range: (profileString as NSString).range(of: appendString))
        attributedQuote.addAttribute(.font, value: UIFont.systemFont(ofSize: changeAppendStringSize, weight: .regular), range: (profileString as NSString).range(of: appendString))
        return attributedQuote
    }
}
