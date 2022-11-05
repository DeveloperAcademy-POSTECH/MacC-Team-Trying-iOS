//
//  WeekdayCell.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class WeekdayCell: UICollectionViewCell {

    let weekdayLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("do not use in storyboard")
    }

    private func setUpView() {
        weekdayLabel.textAlignment = .center
        weekdayLabel.textColor = .designSystem(.calendarYellow)
        weekdayLabel.font = .gmarksans(weight: .bold, size: ._10)

        addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with week: String) {
        weekdayLabel.text = week
    }
}
