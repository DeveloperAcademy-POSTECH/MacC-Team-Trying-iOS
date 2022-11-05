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
    static let numberOfMonthRow: Int = 6
    static let cellHeight: CGFloat = (DeviceInfo.screenWidth - 80 - 1 - CalendarView.inset * 6) / 7
    static let calendarHeight: CGFloat = CGFloat(CalendarView.numberOfMonthRow) * (CalendarView.cellHeight + CalendarView.inset)
    static let height: CGFloat = CGFloat(CalendarView.numberOfMonthRow) * (CalendarView.cellHeight + CalendarView.inset) + 100

    // MARK: - Properties

    weak var delegate: CalendarViewDelegate?

    // 달력과 관련된 프로퍼티

    private var numberOfDaysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private var today: Date
    private var presentMonthDate: Date
    private var previousMonthDate: Date
    private var followingMonthDate: Date

    // 스크롤과 관련된 프로퍼티

    enum ScrollDirection {
        case left
        case right
        case no
    }

    private var scrollDirection: ScrollDirection = .no

    private var scrollViewInset: CGFloat = 20

    private var scrollViewWidth: CGFloat {
        self.frame.width - self.scrollViewInset
    }

    // MARK: - Views

    lazy var monthView = MonthView()
    lazy var weekdayView = WeekdayView()
    lazy var scrollView = UIScrollView()
    lazy var previousMonthCollectionView = PreviousMonthCollectionView()
    lazy var presentMonthCollectionView = PresentMonthCollectionView()
    lazy var followingMonthCollectionView = FollowingMonthCollectionView()

    init(today: Date, frame: CGRect) {
        self.today = today
        self.presentMonthDate = today
        self.previousMonthDate = today.monthBefore ?? .init()
        self.followingMonthDate = today.monthAfter ?? .init()

        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setAttribute() {
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.3
        self.backgroundColor = .designSystem(.calendarRed)?.withAlphaComponent(0.2)

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        previousMonthCollectionView.dataSource = self
        presentMonthCollectionView.dataSource = self
        followingMonthCollectionView.dataSource = self
    }

    override func setLayout() {
        addSubview(monthView)
        addSubview(weekdayView)
        addSubview(scrollView)
        scrollView.addSubview(previousMonthCollectionView)
        scrollView.addSubview(presentMonthCollectionView)
        scrollView.addSubview(followingMonthCollectionView)

        monthView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
        weekdayView.snp.makeConstraints { make in
            make.top.equalTo(monthView.snp.bottom)
            make.height.equalTo(15)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(weekdayView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(scrollViewInset / 2)
            make.height.equalTo(Self.calendarHeight)
            make.bottom.equalToSuperview()
        }
        let scrollViewWidth = self.frame.width - 20
        previousMonthCollectionView.frame = .init(x: 0, y: 0, width: scrollViewWidth, height: Self.calendarHeight)
        presentMonthCollectionView.frame = .init(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: Self.calendarHeight)
        followingMonthCollectionView.frame = .init(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: Self.calendarHeight)

        scrollView.contentSize = .init(width: scrollViewWidth * 3, height: Self.calendarHeight)
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: false)
    }
}

// MARK: UIScrollViewDelegate

extension CalendarView: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch targetContentOffset.pointee.x {
        case 0:
            scrollDirection = .left
        case scrollViewWidth * 1:
            scrollDirection = .no
        case scrollViewWidth * 2:
            scrollDirection = .right
        default:
            break
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDirection {
        case .left:
            updateCalendar(present: previousMonthDate)
        case .right:
            updateCalendar(present: followingMonthDate)
        case .no:
            break
        }
    }

    private func updateCalendar(present: Date) {

        checkLeapYear(date: present)
        
        monthView.updateYearAndMonth(to: present)
        presentMonthDate = present
        previousMonthDate = present.monthBefore ?? .init()
        followingMonthDate = present.monthAfter ?? .init()

        previousMonthCollectionView.reloadData()
        presentMonthCollectionView.reloadData()
        followingMonthCollectionView.reloadData()

        scrollView.setContentOffset(.init(x: scrollViewWidth, y: 0), animated: false)
    }

    private func checkLeapYear(date: Date) {
        if date.month == 2,
           date.year % 4 == 0 {
            numberOfDaysInMonth[1] = 29
        } else {
            numberOfDaysInMonth[1] = 28
        }
    }
}

extension CalendarView: UICollectionViewDataSource {

    var presentYear: Int {
        presentMonthDate.year
    }

    var presentMonth: Int {
        presentMonthDate.month
    }

    var firstWeekdayOfPresentMonth: Int {
        presentMonthDate.firstDayOfTheMonth?.weekday ?? 0
    }

    var startWeekdayOfPresentMonthIndex: Int {
        firstWeekdayOfPresentMonth - 1
    }

    var minimumCellNumberOfPresentMonth: Int {
        numberOfDaysInMonth[presentMonth - 1] + startWeekdayOfPresentMonthIndex
    }

    var previousYear: Int {
        previousMonthDate.year
    }

    var previousMonth: Int {
        previousMonthDate.month
    }

    var firstWeekdayOfPreviousMonth: Int {
        previousMonthDate.firstDayOfTheMonth?.weekday ?? 0
    }

    var startWeekdayOfPreviousMonthIndex: Int {
        firstWeekdayOfPreviousMonth - 1
    }

    var minimumCellNumberOfPreviousMonth: Int {
        numberOfDaysInMonth[previousMonth - 1] + startWeekdayOfPreviousMonthIndex
    }

    var followingYear: Int {
        followingMonthDate.year
    }

    var followingMonth: Int {
        followingMonthDate.month
    }

    var firstWeekdayOfFollowingMonth: Int {
        followingMonthDate.firstDayOfTheMonth?.weekday ?? 0
    }

    var startWeekdayOfFollowingMonthIndex: Int {
        firstWeekdayOfFollowingMonth - 1
    }

    var minimumCellNumberOfFollowingMonth: Int {
        numberOfDaysInMonth[followingMonth - 1] + startWeekdayOfFollowingMonthIndex
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == previousMonthCollectionView {
            let resetCellCount = minimumCellNumberOfPreviousMonth % 7
            return resetCellCount == 0 ? minimumCellNumberOfPreviousMonth : minimumCellNumberOfPreviousMonth + (7 - resetCellCount)
        } else if collectionView == presentMonthCollectionView {
            let resetCellCount = minimumCellNumberOfPresentMonth % 7
            return resetCellCount == 0 ? minimumCellNumberOfPresentMonth : minimumCellNumberOfPresentMonth + (7 - resetCellCount)
        } else {
            let resetCellCount = minimumCellNumberOfFollowingMonth % 7
            return resetCellCount == 0 ? minimumCellNumberOfFollowingMonth : minimumCellNumberOfFollowingMonth + (7 - resetCellCount)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == previousMonthCollectionView {
            return previousCollectionViewCell(for: indexPath, collectionView: collectionView)
        } else if collectionView == presentMonthCollectionView {
            return presentCollectionViewCell(for: indexPath, collectionView: collectionView)
        } else {
            return followingCollectionViewCell(for: indexPath, collectionView: collectionView)
        }
    }

    private func previousCollectionViewCell(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item < startWeekdayOfPreviousMonthIndex {
            return beforeMonthCell(month: previousMonth, startWeekday: startWeekdayOfPreviousMonthIndex, for: indexPath, collectionView: collectionView)
        } else if indexPath.item < minimumCellNumberOfPreviousMonth {
            return followingMonthCell(startWeekday: startWeekdayOfPreviousMonthIndex, for: indexPath, collectionView: collectionView)
        } else {
            return afterMonthCell(minimumCellNumber: minimumCellNumberOfPreviousMonth, for: indexPath, collectionView: collectionView)
        }
    }

    private func presentCollectionViewCell(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item < startWeekdayOfPresentMonthIndex {
            return beforeMonthCell(month: presentMonth, startWeekday: startWeekdayOfPresentMonthIndex, for: indexPath, collectionView: collectionView)
        } else if indexPath.item < minimumCellNumberOfPresentMonth {
            return followingMonthCell(startWeekday: startWeekdayOfPresentMonthIndex, for: indexPath, collectionView: collectionView)
        } else {
            return afterMonthCell(minimumCellNumber: minimumCellNumberOfPresentMonth, for: indexPath, collectionView: collectionView)
        }
    }

    private func followingCollectionViewCell(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item < startWeekdayOfFollowingMonthIndex {
            return beforeMonthCell(month: followingMonth, startWeekday: startWeekdayOfFollowingMonthIndex, for: indexPath, collectionView: collectionView)
        } else if indexPath.item < minimumCellNumberOfFollowingMonth {
            return followingMonthCell(startWeekday: startWeekdayOfFollowingMonthIndex, for: indexPath, collectionView: collectionView)
        } else {
            return afterMonthCell(minimumCellNumber: minimumCellNumberOfFollowingMonth, for: indexPath, collectionView: collectionView)
        }
    }

    private func beforeMonthCell(month: Int, startWeekday: Int, for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let previousMonth = month == 1 ? 12 : month - 1
        let previousMonthDate = numberOfDaysInMonth[previousMonth - 1]
        let day = previousMonthDate - (startWeekday - 1) + indexPath.item
        cell.configure(with: day)
        cell.isPreviousMonthCell()

        return  cell
    }

    private func followingMonthCell(startWeekday: Int, for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let day = indexPath.item - startWeekday + 1
        cell.configure(with: day)
        cell.isFollowingMonthCell()

        return cell
    }

    private func afterMonthCell(minimumCellNumber: Int, for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let day = indexPath.item - minimumCellNumber + 1
        cell.configure(with: day)
        cell.isNextMonthCell()

        return cell
    }
}
