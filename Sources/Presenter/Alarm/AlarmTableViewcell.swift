//
//  AlarmTableViewcell.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

import UIKit

class AlarmTableViewcell: UITableViewCell {

    static let cellID = "AlarmTableViewcell"
    
    private let alarmIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._13)
        label.numberOfLines = 2
        label.textColor = .designSystem(.grayC5C5C5)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._13)
        label.textColor = .designSystem(.grayC5C5C5)
        return label
    }()
    
    var info: AlarmEntity? {
        didSet {
            guard let info = info else { return }
            alarmIconView.image = UIImage(named: info.iconImageString)
            titleLabel.text = info.title
            descriptionLabel.text = info.description
            descriptionLabel.setLineSpacing(spacing: 2)
            timeLabel.text = info.leftTimeString
            backgroundColor = !info.checked ? .designSystem(.mainYellow)?.withAlphaComponent(0.1) : .black
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttributes()
        setLayout()
    }
    
    private func setAttributes() {
        addSubviews(alarmIconView, titleLabel, descriptionLabel, timeLabel)
        separatorInset = .zero
    }
    
    private func setLayout() {
        
        alarmIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmIconView)
            make.leading.equalTo(alarmIconView.snp.trailing).offset(10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(15)
        }

        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(alarmIconView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
