//
//  MonthView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class MonthView: UIView {

    lazy var monthLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupMonthLabel()
    }

    func updateYearAndMonth(to date: Date) {
        updateMonthLabelText(to: date)
    }

    required init?(coder: NSCoder) {
        fatalError("DO Not Use on Storyboard")
    }

    private func setupMonthLabel() {
        updateMonthLabelText(to: .init())
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(20)
        }
    }

    private func updateMonthLabelText(to date: Date) {
        monthLabel.attributedText = NSMutableAttributedString()
            .gmarketLight(string: "\(date.year)  ", fontSize: 15)
            .gmarketBold(string: "\(date.month)월", fontSize: 15)
    }
}
