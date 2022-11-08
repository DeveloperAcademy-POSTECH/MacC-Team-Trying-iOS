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
    func scrollViewDidEndDecelerating()
    func switchCalendarButtonDidTapped()
    func selectDate(_ date: Date?)
}

final class CalendarView: BaseView {

    static let inset: CGFloat = 18
    static let cellHeight: CGFloat = (DeviceInfo.screenWidth - 80 - 1 - CalendarView.inset * 6) / 7

    // MARK: - Properties

    weak var delegate: CalendarViewDelegate?

    private var selectedDate: YearMonthDayDate {
        didSet {
            delegate?.selectDate(selectedDate.asDate())
        }
    }

    // 일정과 관련된 프로퍼티

    var scheduleList: [YearMonthDayDate] = [] {
        didSet {
            previousMonthCollectionView.reloadData()
            presentMonthCollectionView.reloadData()
            followingMonthCollectionView.reloadData()
        }
    }

    // 달력 높이와 관련된 프로퍼티

    private var numberOfMonthRow: Int = 6 {
        didSet {
            scrollView.snp.updateConstraints { make in
                make.height.equalTo(calendarHeight)
            }
            scrollView.contentSize.height = calendarHeight
            delegate?.scrollViewDidEndDecelerating()
        }
    }

    private var calendarHeight: CGFloat {
        CGFloat(numberOfMonthRow) * (CalendarView.cellHeight + CalendarView.inset)
    }

    // 달력과 관련된 프로퍼티

    enum MonthType {
        case previous
        case present
        case following
    }

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

    // 주간 월간 캘린더

    private var calendarShape: MonthView.CalendarShape = .month

    // MARK: - Views

    private lazy var monthView = MonthView(calendarShape: calendarShape)
    private lazy var weekdayView = WeekdayView()
    private lazy var scrollView = UIScrollView()
    private lazy var previousMonthCollectionView = PreviousMonthCollectionView()
    private lazy var presentMonthCollectionView = PresentMonthCollectionView()
    private lazy var followingMonthCollectionView = FollowingMonthCollectionView()

    init(today: Date, frame: CGRect) {
        self.today = today
        self.presentMonthDate = today
        self.previousMonthDate = today.monthBefore ?? .init()
        self.followingMonthDate = today.monthAfter ?? .init()
        self.selectedDate = .init(year: today.year, month: today.month, day: today.day)

        super.init(frame: frame)
        let resetCellCount = minimumCellNumberOfPresentMonth % 7
        numberOfMonthRow = resetCellCount == 0 ? minimumCellNumberOfPresentMonth / 7 : minimumCellNumberOfPresentMonth / 7 + 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setAttribute() {
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.3
        self.backgroundColor = .designSystem(.calendarRed)?.withAlphaComponent(0.2)

        monthView.delegate = self
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        previousMonthCollectionView.dataSource = self
        presentMonthCollectionView.dataSource = self
        presentMonthCollectionView.delegate = self
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
            make.height.equalTo(calendarHeight)
            make.bottom.equalToSuperview()
        }

        let scrollViewWidth = self.frame.width - 20
        previousMonthCollectionView.frame = .init(x: 0, y: 0, width: scrollViewWidth, height: calendarHeight)
        presentMonthCollectionView.frame = .init(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: calendarHeight)
        followingMonthCollectionView.frame = .init(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: calendarHeight)

        scrollView.contentSize = .init(width: scrollViewWidth * 3, height: calendarHeight)
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: false)

        let restCellCount = minimumCellNumberOfPresentMonth % 7
        self.numberOfMonthRow = restCellCount == 0 ? minimumCellNumberOfPresentMonth / 7 : minimumCellNumberOfPresentMonth / 7 + 1
    }
}

// MARK: MonthViewDelegate

extension CalendarView: MonthViewDelegate {

    private var numberOfCalendarRowInMonth: Int {
        let resetCellCount = minimumCellNumberOfPresentMonth % 7
        return resetCellCount == 0 ? minimumCellNumberOfPresentMonth / 7 : minimumCellNumberOfPresentMonth / 7 + 1
    }

    func switchCalendarButtonDidTapped(shape calendarShape: MonthView.CalendarShape) {
        self.calendarShape = calendarShape
        monthView.updateYearAndMonth(to: today)
        presentMonthDate = today
        selectedDate = .init(year: today.year, month: today.month, day: today.day)
        previousMonthDate = presentMonthDate.monthBefore ?? .init()
        followingMonthDate = presentMonthDate.monthAfter ?? .init()

        scrollView.isScrollEnabled = calendarShape == .month
        scrollView.setContentOffset(.init(x: scrollViewWidth, y: 0), animated: false)

        presentMonthCollectionView.performBatchUpdates { [weak self] in
            self?.presentMonthCollectionView.reloadSections(.init(integer: 0))
        }

        numberOfMonthRow = calendarShape == .month ? numberOfCalendarRowInMonth : 1

        delegate?.switchCalendarButtonDidTapped()
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch scrollDirection {
        case .left:
            let restCellCount = minimumCellNumberOfPreviousMonth % 7
            self.numberOfMonthRow = restCellCount == 0 ? minimumCellNumberOfPreviousMonth / 7 : minimumCellNumberOfPreviousMonth / 7 + 1
            if today.year == previousYear, today.month == previousMonth {
                self.selectedDate = .init(year: previousYear, month: previousMonth, day: today.day)
            } else {
                self.selectedDate = .init(year: previousYear, month: previousMonth, day: 1)
            }
        case .right:
            let restCellCount = minimumCellNumberOfFollowingMonth % 7
            self.numberOfMonthRow = restCellCount == 0 ?  minimumCellNumberOfFollowingMonth / 7 : minimumCellNumberOfFollowingMonth / 7 + 1
            if today.year == followingYear, today.month == followingMonth {
                self.selectedDate = .init(year: followingYear, month: followingMonth, day: today.day)
            } else {
                self.selectedDate = .init(year: followingYear, month: followingMonth, day: 1)
            }
        case .no:
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

extension CalendarView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else { return }
        self.selectedDate = .init(year: presentYear, month: presentMonth, day: cell.day)
    }
}

extension CalendarView: UICollectionViewDataSource {

    private var presentYear: Int {
        presentMonthDate.year
    }

    private var presentMonth: Int {
        presentMonthDate.month
    }

    private var firstWeekdayOfPresentMonth: Int {
        presentMonthDate.firstDayOfTheMonth?.weekday ?? 0
    }

    private var startWeekdayOfPresentMonthIndex: Int {
        firstWeekdayOfPresentMonth - 1
    }

    private var minimumCellNumberOfPresentMonth: Int {
        numberOfDaysInMonth[presentMonth - 1] + startWeekdayOfPresentMonthIndex
    }

    private var previousYear: Int {
        previousMonthDate.year
    }

    private var previousMonth: Int {
        previousMonthDate.month
    }

    private var firstWeekdayOfPreviousMonth: Int {
        previousMonthDate.firstDayOfTheMonth?.weekday ?? 0
    }

    private var startWeekdayOfPreviousMonthIndex: Int {
        firstWeekdayOfPreviousMonth - 1
    }

    private var minimumCellNumberOfPreviousMonth: Int {
        numberOfDaysInMonth[previousMonth - 1] + startWeekdayOfPreviousMonthIndex
    }

    private var followingYear: Int {
        followingMonthDate.year
    }

    private var followingMonth: Int {
        followingMonthDate.month
    }

    private var firstWeekdayOfFollowingMonth: Int {
        followingMonthDate.firstDayOfTheMonth?.weekday ?? 0
    }

    private var startWeekdayOfFollowingMonthIndex: Int {
        firstWeekdayOfFollowingMonth - 1
    }

    private var minimumCellNumberOfFollowingMonth: Int {
        numberOfDaysInMonth[followingMonth - 1] + startWeekdayOfFollowingMonthIndex
    }

    private var firstDayOfWeekDay: Int {
        let date = today.day - today.weekday + 1
        return date <= 0 ? numberOfDaysInMonth[today.month - 1] - date : date
    }

    private var lastDayOfWeekDay: Int {
        let date = today.day + (7 - today.weekday)

        return date > numberOfDaysInMonth[today.month] ? date - numberOfDaysInMonth[today.month] : date
    }

    struct WeekDistinguishedByColorModel {
        let thisWeekday: Bool
        let day: Int
    }

    private var thisWeekday: [WeekDistinguishedByColorModel] {

        let firstDayOfWeekday = today.day - today.weekday + 1
        let lastDayOfWeekday = today.day + (7 - today.weekday)

        var result: [WeekDistinguishedByColorModel] = []
        for day in firstDayOfWeekday...lastDayOfWeekday {
            if day < 0 {
                result.append(.init(thisWeekday: false, day: numberOfDaysInMonth[today.month - 1] - day))
            } else if day > numberOfDaysInMonth[today.month] {
                result.append(.init(thisWeekday: false, day: day - numberOfDaysInMonth[today.month]))
            } else {
                result.append(.init(thisWeekday: true, day: day))
            }
        }
        return result
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == previousMonthCollectionView {
            let resetCellCount = minimumCellNumberOfPreviousMonth % 7
            return resetCellCount == 0 ? minimumCellNumberOfPreviousMonth : minimumCellNumberOfPreviousMonth + (7 - resetCellCount)
        } else if collectionView == presentMonthCollectionView {
            switch calendarShape {
            case .month:
                let resetCellCount = minimumCellNumberOfPresentMonth % 7
                return resetCellCount == 0 ? minimumCellNumberOfPresentMonth : minimumCellNumberOfPresentMonth + (7 - resetCellCount)
            case .week:
                return 7
            }

        } else {
            let resetCellCount = minimumCellNumberOfFollowingMonth % 7
            return resetCellCount == 0 ? minimumCellNumberOfFollowingMonth : minimumCellNumberOfFollowingMonth + (7 - resetCellCount)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == previousMonthCollectionView {
            return previousCollectionViewCell(for: indexPath, collectionView: collectionView)
        } else if collectionView == presentMonthCollectionView {
            switch calendarShape {
            case .month:
                return presentCollectionViewCell(for: indexPath, collectionView: collectionView)
            case .week:
                return weekdayCollectionViewCell(for: indexPath)
            }
        } else {
            return followingCollectionViewCell(for: indexPath, collectionView: collectionView)
        }
    }

    private func weekdayCollectionViewCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = presentMonthCollectionView.dequeueReusableCell(DateCell.self, for: indexPath)
        let day = thisWeekday[indexPath.item].day
        let thisMonth: MonthType = thisWeekday[indexPath.item].thisWeekday ? .present : .following
        cell.configure(with: day, isSchedule: checkSchedule(day: day, type: thisMonth))

        // 오늘인지 체크
        if findToday(day: day, type: thisMonth) {
            cell.isToday()
        } else {
            cell.isPresentMonthCell()
        }

        if selectedDate == .init(year: presentYear, month: presentMonth, day: day) {
            presentMonthCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }

        return cell
    }
    private func previousCollectionViewCell(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item < startWeekdayOfPreviousMonthIndex {
            return previousMonthCell(month: previousMonth, startWeekday: startWeekdayOfPreviousMonthIndex, for: indexPath, collectionView: collectionView)
        } else if indexPath.item < minimumCellNumberOfPreviousMonth {
            return presentMonthCell(startWeekday: startWeekdayOfPreviousMonthIndex, for: indexPath, collectionView: collectionView, type: .previous)
        } else {
            return followingMonthCell(minimumCellNumber: minimumCellNumberOfPreviousMonth, for: indexPath, collectionView: collectionView)
        }
    }

    private func presentCollectionViewCell(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item < startWeekdayOfPresentMonthIndex {
            return previousMonthCell(month: presentMonth, startWeekday: startWeekdayOfPresentMonthIndex, for: indexPath, collectionView: collectionView)
        } else if indexPath.item < minimumCellNumberOfPresentMonth {
            return presentMonthCell(startWeekday: startWeekdayOfPresentMonthIndex, for: indexPath, collectionView: collectionView, type: .present)
        } else {
            return followingMonthCell(minimumCellNumber: minimumCellNumberOfPresentMonth, for: indexPath, collectionView: collectionView)
        }
    }

    private func followingCollectionViewCell(for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item < startWeekdayOfFollowingMonthIndex {
            return previousMonthCell(month: followingMonth, startWeekday: startWeekdayOfFollowingMonthIndex, for: indexPath, collectionView: collectionView)
        } else if indexPath.item < minimumCellNumberOfFollowingMonth {
            return presentMonthCell(startWeekday: startWeekdayOfFollowingMonthIndex, for: indexPath, collectionView: collectionView, type: .following)
        } else {
            return followingMonthCell(minimumCellNumber: minimumCellNumberOfFollowingMonth, for: indexPath, collectionView: collectionView)
        }
    }

    private func previousMonthCell(month: Int, startWeekday: Int, for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let previousMonth = month == 1 ? 12 : month - 1
        let previousMonthDate = numberOfDaysInMonth[previousMonth - 1]
        let day = previousMonthDate - (startWeekday - 1) + indexPath.item
        cell.configure(with: day, isSchedule: checkSchedule(day: day, type: .previous))
        cell.isPreviousMonthCell()

        return  cell
    }

    private func presentMonthCell(startWeekday: Int, for indexPath: IndexPath, collectionView: UICollectionView, type: MonthType) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let day = indexPath.item - startWeekday + 1
        cell.configure(with: day, isSchedule: checkSchedule(day: day, type: type))

        // 오늘인지 체크
        if findToday(day: day, type: type) {
            cell.isToday()
        } else {
            cell.isPresentMonthCell()
        }

        if selectedDate == .init(year: presentYear, month: presentMonth, day: day) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }

        return cell
    }

    private func followingMonthCell(minimumCellNumber: Int, for indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DateCell.self, for: indexPath)

        let day = indexPath.item - minimumCellNumber + 1
        cell.configure(with: day, isSchedule: checkSchedule(day: day, type: .following))
        cell.isFollowingMonthCell()

        return cell
    }

    // 스케쥴이 있다는 것을 체크하는 함수입니다.
    private func checkSchedule(day: Int, type: MonthType) -> Bool {
        switch type {
        case .previous:
            let date = YearMonthDayDate(year: previousYear, month: previousMonth, day: day)
            return scheduleList.contains(date)
        case .present:
            let date = YearMonthDayDate(year: presentYear, month: presentMonth, day: day)
            return scheduleList.contains(date)
        case .following:
            let date = YearMonthDayDate(year: followingYear, month: followingMonth, day: day)
            return scheduleList.contains(date)
        }
    }

    private func findToday(day: Int, type: MonthType) -> Bool {
        switch type {
        case .previous:
            return (day == today.day && previousMonth == today.month && previousYear == today.year)
        case .present:
            return (day == today.day && presentMonth == today.month && presentYear == today.year)
        case .following:
            return (day == today.day && followingMonth == today.month && followingYear == today.year)
        }
    }
}
