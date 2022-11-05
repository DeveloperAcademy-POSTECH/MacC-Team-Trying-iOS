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

    lazy var yearAndMonth: String = "0000-00" {
        didSet {
            let dateInfos = yearAndMonth.components(separatedBy: "-").map { Int($0)! }
            let (year, month) = (dateInfos[0], dateInfos[1])
            if month < 10 { yearAndMonth = "\(year)-0\(month)" }
            updateMonthLabelText(to: yearAndMonth)
        }
    }

    lazy var monthLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupMonthLabel()
    }

    func updateYearAndMonth(to date: Date) {
        let newYearAndMonth = "\(date.year)-\(date.month)"
        yearAndMonth = newYearAndMonth
    }

    required init?(coder: NSCoder) {
        fatalError("DO Not Use on Storyboard")
    }

    private func setupMonthLabel() {
        updateMonthLabelText(to: "\(Date().year)-\(Date().month)")
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(20)
        }
    }

    private func updateMonthLabelText(to yearAndMonth: String) {
        monthLabel.attributedText = NSMutableAttributedString()
            .gmarketLight(string: "2022 ", fontSize: 15)
            .gmarketBold(string: "11월", fontSize: 15)

    }
}
