//
//  DateCell.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

struct DateCellModel: Hashable {
    let date: YearMonthDayDate
    let isScheduled: Bool
    let isColored: Bool
}

final class DateCollectionViewCell: UICollectionViewCell {

    lazy var circleView = UIView()
    lazy var dateLabel = UILabel()
    lazy var scheduleDotView = UIView()

    override var isSelected: Bool {
        didSet {
            let backgroundColor: UIColor = isSelected ? .black : .clear
            self.circleView.backgroundColor = backgroundColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        dateLabel.font = .gmarksans(weight: .bold, size: ._13)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        scheduleDotView.backgroundColor = .designSystem(.mainYellow)
        contentView.backgroundColor = .clear
        circleView.backgroundColor = .clear
        contentView.addSubview(circleView)
        circleView.addSubview(dateLabel)
        circleView.addSubview(scheduleDotView)
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
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

        // 18은 Inset이었음.
        let width = (DeviceInfo.screenWidth - 80 - 16 * 6 - 1) / 7
        circleView.layer.cornerRadius = width / 2
        circleView.layer.masksToBounds = true
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

        circleView.backgroundColor = .clear
        scheduleDotView.isHidden = true
        dateLabel.textColor = .white
        scheduleDotView.backgroundColor = .designSystem(.mainYellow)
    }
}
