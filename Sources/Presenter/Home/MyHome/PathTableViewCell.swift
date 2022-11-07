//
//  CourseTableViewCell.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class PathTableViewCell: UITableViewCell {
    
    static let cellId = "PathTableViewCell"
    
    var data: DatePath? {
        didSet {
            guard let data = data else { return }
            title.text = data.title
            comment.text = data.comment
            guard let distance = data.distance else { return }
            self.distance.text = distance.changeDistance()
        }
    }
    
    let title: UILabel = {
        let v = UILabel()
        v.font = UIFont.gmarksans(weight: .medium, size: ._13)
        v.textColor = .white
        return v
    }()
    
    let comment: UILabel = {
        let v = UILabel()
        v.font = UIFont.gmarksans(weight: .light, size: ._10)
        v.textColor = .white
        return v
    }()
    
    let distance: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 10, weight: .regular)
        v.textColor = .white.withAlphaComponent(0.5)
        return v
    }()
    
    let pointCircle: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "PathPoint")
        return v
    }()
    
    let lineUpper: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let lineLower: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let findPathButton: UIButton = {
        let v = UIButton(type: .custom)
        v.setImage(UIImage(named: "FindPathButton"), for: .normal)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubviews(title, comment, distance, pointCircle, lineUpper, lineLower)
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(70)
            make.height.equalTo(15)
        }
        
        comment.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.leading.equalTo(title.snp.leading)
            make.height.equalTo(12)
        }
        
        distance.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
        pointCircle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(48)
            make.size.equalTo(12)
        }
        
        lineUpper.snp.makeConstraints { make in
            make.width.equalTo(1.5)
            make.centerX.equalTo(pointCircle.snp.centerX)
            make.top.equalToSuperview()
            make.bottom.equalTo(pointCircle.snp.centerY)
        }
        
        lineLower.snp.makeConstraints { make in
            make.width.equalTo(1.5)
            make.centerX.equalTo(pointCircle.snp.centerX)
            make.top.equalTo(pointCircle.snp.centerY)
            make.bottom.equalToSuperview()
        }
    }
    
}
