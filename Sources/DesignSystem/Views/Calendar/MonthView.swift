//
//  MonthView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

protocol MonthViewDelegate: AnyObject {
    func changeButtonDidTapped(shape calendarShape: MonthView.CalendarShape)
}

final class MonthView: UIView {

    lazy var monthLabel = UILabel()
    lazy var changeButton = UIButton(type: .system)

    weak var delegate: MonthViewDelegate?

    var calendarShape: CalendarShape = .month

    enum CalendarShape {
        case week
        case month

        var buttonImage: UIImage? {
            switch self {
            case .week:
                return .init(.btn_week_calendar)
            case .month:
                return .init(.btn_month_calendar)
            }
        }
    }

    convenience init(calendarShape: CalendarShape) {
        self.init(frame: .zero)
        self.calendarShape = calendarShape
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupMonthLabel()
        setupChangeButton()
    }

    func updateYearAndMonth(to date: Date) {
        updateMonthLabelText(to: date)
    }

    @objc
    func changeButtonDidTapped() {
        calendarShape = calendarShape == .month ? .week : .month
        delegate?.changeButtonDidTapped(shape: calendarShape)
        changeButton.setImage(calendarShape.buttonImage, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("DO Not Use on Storyboard")
    }

    private func setupChangeButton() {
        changeButton.setImage(.init(.btn_week_calendar), for: .normal)
        changeButton.addTarget(self, action: #selector(changeButtonDidTapped), for: .touchUpInside)

        addSubview(changeButton)
        changeButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.leading.equalTo(monthLabel.snp.trailing).offset(6)
            make.width.equalTo(32)
            make.height.equalTo(17)
        }
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
