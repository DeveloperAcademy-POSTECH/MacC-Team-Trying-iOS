//
//  DateTableViewCell.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class DateTableViewCell: UITableViewCell {
    
    var dateData: DateDday? {
        didSet {
            guard let dateData = dateData else { return }
            title.text = "⭐️\(dateData.title) D-\(dateData.dday)"
        }
    }
    
    static let cellId = "DateTableViewCell"
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .light, size: ._13)
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        addSubview(title)
        title.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(15)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
}
