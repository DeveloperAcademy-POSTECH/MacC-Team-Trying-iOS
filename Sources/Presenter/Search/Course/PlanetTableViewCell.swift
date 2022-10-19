//
//  PlanetTableViewCell.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {

    static let identifier = "PlanetTableViewCell"
    
    var info: Info2? {
        didSet {
            guard let info = info else {
                return
            }
            planetImageView.image = UIImage(named: info.planetImageString)
            planetNameLabel.text = info.planetNameString
            ownerLabel.text = info.hosts.joined(separator: ", ")
            followButton.isSelected = info.isFollow
        }
    }
    
    private var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .gray
        return view
    }()
    
    private var planetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var planetNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var followButton: FollowButton = {
        let button = FollowButton()
        button.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)
        return button
    }()
    
    private lazy var planetNameOwnersVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [planetNameLabel, ownerLabel])
        stackView.spacing = 7
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        configure()
        setAttributes()
        setConstraints()
    }
    
    private func configure() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setAttributes() {
        
        containerView.addSubview(planetImageView)
        containerView.addSubview(planetNameOwnersVStackView)
        containerView.addSubview(followButton)
        contentView.addSubview(containerView)
    }

    private func setConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(90)
        }

        planetImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(planetImageView)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(67.5)
            make.height.equalTo(25)
        }
        
        planetNameOwnersVStackView.snp.makeConstraints { make in
            make.leading.equalTo(planetImageView.snp.trailing).offset(10)
            make.trailing.equalTo(followButton.snp.leading).offset(4)
            make.centerY.equalTo(planetImageView)
        }

    }
    
    @objc private func toggleFollow() {
        //TODO: ViewModel을 통한 toggle
        followButton.isSelected.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
