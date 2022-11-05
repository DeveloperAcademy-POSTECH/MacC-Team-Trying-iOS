//
//  DateCell.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class DateCell: UICollectionViewCell {
    lazy var dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        dateLabel.font = .gmarksans(weight: .bold, size: ._13)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with day: Int) {
        dateLabel.text = String(day)

    }

    func isPreviousMonthCell() {
        dateLabel.textColor = .white.withAlphaComponent(0.3)
    }

    func isFollowingMonthCell() {
        dateLabel.textColor = .white
    }

    func isNextMonthCell() {
        dateLabel.textColor = .white.withAlphaComponent(0.3)
    }
}
