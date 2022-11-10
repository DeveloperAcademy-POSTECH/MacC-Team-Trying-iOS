//
//  DateCell.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

struct DateCellModel: Hashable {
    let date: YearMonthDayDate
    let isScheduled: Bool
    let isColored: Bool
}

final class DateCollectionViewCell: UICollectionViewCell {

    lazy var dateLabel = UILabel()
    lazy var scheduleDotView = UIView()

    override var isSelected: Bool {
        didSet {
            let backgroundColor: UIColor = isSelected ? .black : .clear
            self.contentView.backgroundColor = backgroundColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        dateLabel.font = .gmarksans(weight: .bold, size: ._13)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        scheduleDotView.backgroundColor = .designSystem(.mainYellow)
        contentView.backgroundColor = .clear
        contentView.addSubview(dateLabel)
        contentView.addSubview(scheduleDotView)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        scheduleDotView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(3)
        }

        contentView.layer.cornerRadius = contentView.bounds.width / 2
        scheduleDotView.layer.cornerRadius = 1.5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: DateCellModel) {
        let dotColor: UIColor? = model.isScheduled ? .designSystem(.mainYellow) : .designSystem(.mainYellow)?.withAlphaComponent(0.3)
        let dateLabelColor: UIColor? = model.isColored ? .white : .white.withAlphaComponent(0.3)
        dateLabel.text = String(model.date.day)
        scheduleDotView.isHidden = model.isScheduled == false
        scheduleDotView.backgroundColor = dotColor
        dateLabel.textColor = dateLabelColor
    }

    func isToday() {
        dateLabel.textColor = .yellow
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        contentView.backgroundColor = .clear
        scheduleDotView.isHidden = true
        dateLabel.textColor = .white
        scheduleDotView.backgroundColor = .designSystem(.mainYellow)
    }
}
