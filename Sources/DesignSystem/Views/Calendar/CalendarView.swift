//
//  CalendarView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

protocol CalendarViewDelegate: AnyObject {
    func layoutIfNeeded()
}

final class CalendarView: BaseView {
    static let inset: CGFloat = 18
    static let numberOfMonthRow: Int = 5
    static let cellHeight: CGFloat = (DeviceInfo.screenWidth - 80 - 1 - CalendarView.inset * 6) / 7
    static let height: CGFloat = CGFloat(CalendarView.numberOfMonthRow) * (CalendarView.cellHeight + CalendarView.inset) + 100

    // MARK: - Properties

    weak var delegate: CalendarViewDelegate?

    let numberOfDaysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var today: Date

    var presentMonth: Int {
        today.month
    }

    var firstWeekdayOfPresentedMonth: Int {
        today.firstDayOfTheMonth?.weekday ?? 0
    }

    // MARK: - Views

    lazy var monthView = MonthView()
    lazy var weekdayView = WeekdayView()
    lazy var calendarCollectionView = CalendarCollectionView()

    init(today: Date) {
        self.today = today
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setAttribute() {
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.3
        self.backgroundColor = .designSystem(.calendarRed)?.withAlphaComponent(0.2)

        calendarCollectionView.dataSource = self
    }

    override func setLayout() {
        addSubview(monthView)
        addSubview(weekdayView)
        addSubview(calendarCollectionView)

        monthView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
        weekdayView.snp.makeConstraints { make in
            make.top.equalTo(monthView.snp.bottom)
            make.height.equalTo(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension CalendarView: UICollectionViewDataSource {

    var startWeekdayOfMonthIndex: Int {
        firstWeekdayOfPresentedMonth - 1
    }

    var minimumCellNumber: Int {
        numberOfDaysInMonth[presentMonth - 1] + startWeekdayOfMonthIndex
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        minimumCellNumber % 7 == 0 ? minimumCellNumber : minimumCellNumber + (7 - minimumCellNumber % 7)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item < startWeekdayOfMonthIndex {
            return beforeMonthCell(for: indexPath)
        } else if indexPath.item < minimumCellNumber {
            return followingMonthCell(for: indexPath)
        } else {
            return afterMonthCell(for: indexPath)
        }
    }

    private func beforeMonthCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarCollectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let previousMonth = presentMonth == 1 ? 12 : presentMonth - 1
        let previousMonthDate = numberOfDaysInMonth[previousMonth - 1]
        let day = previousMonthDate - (startWeekdayOfMonthIndex - 1) + indexPath.item
        cell.configure(with: day)
        cell.isPreviousMonthCell()

        return  cell
    }

    private func followingMonthCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarCollectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let day = indexPath.item - startWeekdayOfMonthIndex + 1
        cell.configure(with: day)
        cell.isFollowingMonthCell()

        return cell
    }

    private func afterMonthCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarCollectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let day = indexPath.item - minimumCellNumber + 1
        cell.configure(with: day)
        cell.isNextMonthCell()

        return cell
    }
}
