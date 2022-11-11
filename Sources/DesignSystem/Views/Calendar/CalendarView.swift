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

    static let inset: CGFloat = 0
    static let cellHeight: CGFloat = (DeviceInfo.screenWidth - 80 - 1 - CalendarView.inset * 6) / 7

    // MARK: - Properties

    weak var delegate: CalendarViewDelegate?

    private var selectedDate: YearMonthDayDate {
        didSet {
            monthView.updateYearAndMonth(to: selectedDate.asDate())
            delegate?.selectDate(selectedDate.asDate())
        }
    }

    // 일정과 관련된 프로퍼티

    var scheduleList: [YearMonthDayDate] = [] {
        didSet {
            sections = calculateSections()
            applySnapshot(section: sections)
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
        CGFloat(numberOfMonthRow) * (CalendarView.cellHeight + CalendarView.inset) + 10
    }

    // 달력과 관련된 프로퍼티

    enum MonthType {
        case previous
        case present
        case following
    }

    typealias Section = CalendarSection
    typealias PresentCalendarDataSource = PresentCalendarDiffableDataSource
    typealias FollowingCalendarDataSource = FollowingCalendarDiffableDataSource
    typealias PrevioustCalendarDataSource = PreviousCalendarDiffableDataSource
    typealias DateSnapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>

    private lazy var previousDataSource = PresentCalendarDataSource(collectionView: previousMonthCollectionView)
    private lazy var presentDataSource = PresentCalendarDataSource(collectionView: presentMonthCollectionView)
    private lazy var followingDataSource = PresentCalendarDataSource(collectionView: followingMonthCollectionView)

    private var numberOfDaysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private var sections: [CalendarSection] = []
    private var today: Date

    private var previousFirstDayOfWeek: Date
    private var presentFirstDayOfWeek: Date
    private var followingFirstDayOfWeek: Date
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
        self.previousMonthDate = today.monthBefore
        self.followingMonthDate = today.monthAfter
        self.selectedDate = .init(year: today.year, month: today.month, day: today.day)
        self.presentFirstDayOfWeek = today.startDateOfWeek
        self.previousFirstDayOfWeek = presentFirstDayOfWeek.day(before: 7)
        self.followingFirstDayOfWeek = presentFirstDayOfWeek.day(after: 7)
        super.init(frame: frame)

        self.sections = calculateSections()
        applySnapshot(section: sections)
        numberOfMonthRow = presentFrontCellNumber == 0 ?
        minimumCellNumberOfPresentMonth / 7 :
        minimumCellNumberOfPresentMonth / 7 + 1
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

        presentMonthCollectionView.delegate = self
        previousMonthCollectionView.dataSource = previousDataSource
        presentMonthCollectionView.dataSource = presentDataSource
        followingMonthCollectionView.dataSource = followingDataSource
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
            make.top.equalTo(weekdayView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(scrollViewInset / 2)
            make.height.equalTo(calendarHeight)
            make.bottom.equalToSuperview()
        }

        let scrollViewWidth = self.frame.width - 20
        previousMonthCollectionView.frame = .init(
            x: 0, y: 0, width: scrollViewWidth, height: calendarHeight
        )
        
        presentMonthCollectionView.frame = .init(
            x: scrollViewWidth, y: 0, width: scrollViewWidth, height: calendarHeight
        )
        
        followingMonthCollectionView.frame = .init(
            x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: calendarHeight
        )
    
        scrollView.contentSize = .init(width: scrollViewWidth * 3, height: calendarHeight)
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: false)

        let restCellCount = minimumCellNumberOfPresentMonth % 7
        self.numberOfMonthRow = restCellCount == 0 ?
        minimumCellNumberOfPresentMonth / 7 :
        minimumCellNumberOfPresentMonth / 7 + 1
    }
}

// MARK: MonthViewDelegate

extension CalendarView: MonthViewDelegate {

    private var numberOfCalendarRowInMonth: Int {
        let resetCellCount = minimumCellNumberOfPresentMonth % 7
        return resetCellCount == 0 ? minimumCellNumberOfPresentMonth / 7 : minimumCellNumberOfPresentMonth / 7 + 1
    }

    func switchCalendarButtonDidTapped(shape calendarShape: MonthView.CalendarShape) {
        deSelectAll()

        self.calendarShape = calendarShape

        switch calendarShape {
        case .week:
            // 오늘 주로 수정
            presentFirstDayOfWeek = today.startDateOfWeek
            previousFirstDayOfWeek = presentFirstDayOfWeek.day(before: 7)
            followingFirstDayOfWeek = presentFirstDayOfWeek.day(after: 7)

            numberOfMonthRow = 1
        case .month:
            // 오늘로 수정
            presentMonthDate = today
            previousMonthDate = presentMonthDate.monthBefore
            followingMonthDate = presentMonthDate.monthAfter

            numberOfMonthRow = numberOfCalendarRowInMonth
        }

        selectedDate = .init(year: today.year, month: today.month, day: today.day)
        monthView.updateYearAndMonth(to: today)
        sections = calculateSections()
        applySnapshot(section: sections, isAnimating: true)
        delegate?.switchCalendarButtonDidTapped()
    }

    private func deSelectAll() {
        if let indexPaths = presentMonthCollectionView.indexPathsForSelectedItems {
            indexPaths.forEach { indexPath in
                presentMonthCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }
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

    // 스크롤이 된 후,
    // 1. 선택된 날짜를 변경
    //  - 오늘이 없다면, 1일(월간) / 일요일(주간) 날짜 선택
    // 2. 높이 조절
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch scrollDirection {
        case .left:
            switch calendarShape {
            case .month:
                self.numberOfMonthRow = previousFrontCellNumber == 0 ?
                minimumCellNumberOfPreviousMonth / 7 :
                minimumCellNumberOfPreviousMonth / 7 + 1
                let day = (today.year == previousYear && today.month == previousMonth) ? today.day : 1
                self.selectedDate = .init(year: previousYear, month: previousMonth, day: day)
            case .week:
                let day = previousFirstDayOfWeek.isDateInThisWeek() ? today.day : previousFirstDayOfWeek.day
                self.selectedDate = .init(year: previousFirstDayOfWeek.year, month: previousFirstDayOfWeek.month, day: day)
            }
        case .right:
            switch calendarShape {
            case .month:
                self.numberOfMonthRow = followingFrontCellNumber == 0 ?
                minimumCellNumberOfFollowingMonth / 7 :
                minimumCellNumberOfFollowingMonth / 7 + 1
                let day = (today.year == followingYear && today.month == followingMonth) ? today.day : 1
                self.selectedDate = .init(year: followingYear, month: followingMonth, day: day)
            case .week:
                let day = followingFirstDayOfWeek.isDateInThisWeek() ? today.day : followingFirstDayOfWeek.day
                self.selectedDate = .init(year: followingFirstDayOfWeek.year, month: followingFirstDayOfWeek.month, day: day)
            }
        case .no:
            break
        }
        // MARK: - 여기서 3월 달력을 보여주면 2월1일, 5월1일을 서버에 request로 보내준다
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDirection {
        case .left:
            switch calendarShape {
            case .week:
                updateCalendar(present: previousFirstDayOfWeek)
            case .month:
                updateCalendar(present: previousMonthDate)
            }
        case .right:
            switch calendarShape {
            case .week:
                updateCalendar(present: followingFirstDayOfWeek)
            case .month:
                updateCalendar(present: followingMonthDate)
            }
        case .no:
            break
        }
    }

    private func updateCalendar(present: Date) {
        checkLeapYear(date: present)
        monthView.updateYearAndMonth(to: present)
        switch calendarShape {
        case .month:
            presentMonthDate = present
            previousMonthDate = present.monthBefore
            followingMonthDate = present.monthAfter

            self.presentMonthCollectionView.selectItem(
                at: .init(item: startWeekdayOfPresentMonthIndex - 1, section: 0),
                animated: true,
                scrollPosition: .top
            )
        case .week:
            presentFirstDayOfWeek = present
            previousFirstDayOfWeek = present.day(before: 7)
            followingFirstDayOfWeek = present.day(after: 7)
            self.presentMonthCollectionView.selectItem(
                at: .init(item: 0, section: 0),
                animated: true,
                scrollPosition: .top
            )
        }

        sections = calculateSections()
        applySnapshot(section: sections)
        scrollView.setContentOffset(.init(x: scrollViewWidth, y: 0), animated: false)

        // 눌림 처리
        switch calendarShape {
        case .month:
            if presentMonthCollectionView.indexPathsForSelectedItems?.isEmpty ?? true {
                self.presentMonthCollectionView.selectItem(
                    at: IndexPath(item: startWeekdayOfPresentMonthIndex, section: 0),
                    animated: true,
                    scrollPosition: .top
                )
            }
        case .week:
            if presentMonthCollectionView.indexPathsForSelectedItems?.isEmpty ?? true {
                self.presentMonthCollectionView.selectItem(
                    at: IndexPath(item: 0, section: 0),
                    animated: true,
                    scrollPosition: .top
                )
            }
        }
    }

    private func calculateSections() -> [CalendarSection] {
        switch calendarShape {
        case .month:
            return monthCalendarSections()
        case .week:
            return weekCalendarSections()
        }
    }

    private func monthCalendarSections() -> [CalendarSection] {
        var sections: [CalendarSection] = []
        var dateCellModels: [DateCellModel] = []

        // 이전 달력
        for index in 0..<totalCellNumberOfPreviousCalendar {
            // 이전 달력의 달
            if index < startWeekdayOfPreviousMonthIndex {
                let previousMonth = previousMonth == 1 ? 12 : previousMonth - 1
                let previousMonthDate = numberOfDaysInMonth[previousMonth - 1]
                let day = previousMonthDate - (startWeekdayOfPreviousMonthIndex - 1) + index
                let isChecked = scheduleList.contains(
                    .init(year: previous2Year, month: previous2Month, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: previous2Year, month: previous2Month, day: day),
                    isScheduled: isChecked,
                    isColored: false
                ))
            } else if index < minimumCellNumberOfPreviousMonth {
                let day = index - startWeekdayOfPreviousMonthIndex + 1
                let isChecked = scheduleList.contains(
                    .init(year: previousYear, month: previousMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: previousYear, month: previousMonth, day: day),
                    isScheduled: isChecked,
                    isColored: true
                ))
            } else {
                let day = index - minimumCellNumberOfPreviousMonth + 1
                let isChecked = scheduleList.contains(
                    .init(year: presentYear, month: presentMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: presentYear, month: presentMonth, day: day),
                    isScheduled: isChecked,
                    isColored: false
                ))
            }
        }
        sections.append(.month(dateCellModels.map { .day($0) }))
        // 현재 달력
        dateCellModels = []
        for index in 0..<totalCellNumberOfPresentCalendar {
            // 이전 달력의 달
            if index < startWeekdayOfPresentMonthIndex {
                let previousMonthDate = numberOfDaysInMonth[previousMonth - 1]
                let day = previousMonthDate - (startWeekdayOfPresentMonthIndex - 1) + index
                let isChecked = scheduleList.contains(
                    .init(year: previousYear, month: previousMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: previousYear, month: previousMonth, day: day),
                    isScheduled: isChecked,
                    isColored: false
                ))
            } else if index < minimumCellNumberOfPresentMonth {
                let day = index - startWeekdayOfPresentMonthIndex + 1
                let isChecked = scheduleList.contains(
                    .init(year: presentYear, month: presentMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: presentYear, month: presentMonth, day: day),
                    isScheduled: isChecked,
                    isColored: true
                ))
            } else {
                let day = index - minimumCellNumberOfPresentMonth + 1
                let isChecked = scheduleList.contains(
                    .init(year: followingYear, month: followingMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: followingYear, month: followingMonth, day: day),
                    isScheduled: isChecked,
                    isColored: false
                ))
            }
        }
        sections.append(.month(dateCellModels.map { .day($0) }))

        // 다음 달력
        dateCellModels = []
        for index in 0..<totalCellNumberOfFollowingCalendar {
            // 이전 달력의 달
            if index < startWeekdayOfFollowingMonthIndex {
                let previousMonthDate = numberOfDaysInMonth[presentMonth - 1]
                let day = previousMonthDate - (startWeekdayOfFollowingMonthIndex - 1) + index
                let isChecked = scheduleList.contains(
                    .init(year: presentYear, month: presentMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: presentYear, month: presentMonth, day: day),
                    isScheduled: isChecked,
                    isColored: false
                ))
            } else if index < minimumCellNumberOfFollowingMonth {
                let day = index - startWeekdayOfFollowingMonthIndex + 1
                let isChecked = scheduleList.contains(
                    .init(year: followingYear, month: followingMonth, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: followingYear, month: followingMonth, day: day),
                    isScheduled: isChecked,
                    isColored: true
                ))
            } else {
                let day = index - minimumCellNumberOfFollowingMonth + 1
                let isChecked = scheduleList.contains(
                    .init(year: following2Year, month: following2Year, day: day)
                )
                dateCellModels.append(.init(
                    date: .init(year: following2Year, month: following2Year, day: day),
                    isScheduled: isChecked,
                    isColored: false
                ))
            }
        }
        sections.append(.month(dateCellModels.map { .day($0) }))

        return sections
    }

    private func weekCalendarSections() -> [CalendarSection] {
        var sections: [CalendarSection] = []
        var dateCellModels: [DateCellModel] = []

        for index in 0..<7 {
            let date = previousFirstDayOfWeek.day(after: index)
            let isChecked = scheduleList.contains(
                .init(year: date.year, month: date.month, day: date.day)
            )
            dateCellModels.append(.init(
                date: .init(year: date.year, month: date.month, day: date.day),
                isScheduled: isChecked,
                isColored: true
            ))
        }
        sections.append(.week(dateCellModels.map { .day($0) }))

        dateCellModels = []
        for index in 0..<7 {
            let date = presentFirstDayOfWeek.day(after: index)
            let isChecked = scheduleList.contains(
                .init(year: date.year, month: date.month, day: date.day)
            )
            dateCellModels.append(.init(
                date: .init(year: date.year, month: date.month, day: date.day),
                isScheduled: isChecked,
                isColored: true
            ))
        }
        sections.append(.week(dateCellModels.map { .day($0) }))

        dateCellModels = []
        for index in 0..<7 {
            let date = followingFirstDayOfWeek.day(after: index)
            let isChecked = scheduleList.contains(
                .init(year: date.year, month: date.month, day: date.day)
            )
            dateCellModels.append(.init(
                date: .init(year: date.year, month: date.month, day: date.day),
                isScheduled: isChecked,
                isColored: true
            ))
        }
        sections.append(.week(dateCellModels.map { .day($0) }))

        return sections
    }

    private func applySnapshot(section: [CalendarSection], isAnimating: Bool = false) {

        [previousDataSource, presentDataSource, followingDataSource].enumerated().forEach { index, dataSource in
            var snapshot = DateSnapshot()
            let section = [section[index]]
            snapshot.appendSections(section)
            section.forEach { section in
                switch section {
                case .month(let models):
                    snapshot.appendItems(models)
                case .week(let models):
                    snapshot.appendItems(models)
                }
            }
            dataSource.apply(snapshot, animatingDifferences: isAnimating)
        }
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
        guard let cell = presentDataSource.itemIdentifier(for: indexPath) else { return }
        guard case .day(let model) = cell else { return }
        self.selectedDate = model.date
    }
}

extension CalendarView {

    // 현재 달
    private var presentYear: Int {
        presentMonthDate.year
    }

    private var presentMonth: Int {
        presentMonthDate.month
    }

    private var firstWeekdayOfPresentMonth: Int {
        presentMonthDate.firstDayOfTheMonth.weekday
    }

    private var startWeekdayOfPresentMonthIndex: Int {
        firstWeekdayOfPresentMonth - 1
    }

    private var minimumCellNumberOfPresentMonth: Int {
        numberOfDaysInMonth[presentMonth - 1] + startWeekdayOfPresentMonthIndex
    }

    private var presentFrontCellNumber: Int {
        minimumCellNumberOfPresentMonth % 7
    }

    private var totalCellNumberOfPresentCalendar: Int {
        presentFrontCellNumber == 0 ?
        minimumCellNumberOfPresentMonth :
        minimumCellNumberOfPresentMonth + (7 - presentFrontCellNumber)
    }

    // 이전 달

    /// 현재에서 두 달 이전 year
    private var previous2Year: Int {
        previousMonthDate.monthBefore.year
    }

    /// 현재에서 두 달 이전 year
    private var previous2Month: Int {
        previousMonthDate.monthBefore.month
    }

    private var previousYear: Int {
        previousMonthDate.year
    }

    private var previousMonth: Int {
        previousMonthDate.month
    }

    private var firstWeekdayOfPreviousMonth: Int {
        previousMonthDate.firstDayOfTheMonth.weekday
    }

    private var startWeekdayOfPreviousMonthIndex: Int {
        firstWeekdayOfPreviousMonth - 1
    }

    private var minimumCellNumberOfPreviousMonth: Int {
        numberOfDaysInMonth[previousMonth - 1] + startWeekdayOfPreviousMonthIndex
    }

    private var previousFrontCellNumber: Int {
        minimumCellNumberOfPreviousMonth % 7
    }

    private var totalCellNumberOfPreviousCalendar: Int {
        previousFrontCellNumber == 0 ?
        minimumCellNumberOfPreviousMonth :
        minimumCellNumberOfPreviousMonth + (7 - previousFrontCellNumber)
    }
    // 다음 달

    /// 현재에서 두 달 이후 year
    private var following2Year: Int {
        previousMonthDate.monthAfter.year
    }

    /// 현재에서 두 달 이후 month
    private var following2Month: Int {
        previousMonthDate.monthAfter.month
    }

    private var followingYear: Int {
        followingMonthDate.year
    }

    private var followingMonth: Int {
        followingMonthDate.month
    }

    private var firstWeekdayOfFollowingMonth: Int {
        followingMonthDate.firstDayOfTheMonth.weekday
    }

    private var startWeekdayOfFollowingMonthIndex: Int {
        firstWeekdayOfFollowingMonth - 1
    }

    private var minimumCellNumberOfFollowingMonth: Int {
        numberOfDaysInMonth[followingMonth - 1] + startWeekdayOfFollowingMonthIndex
    }

    private var followingFrontCellNumber: Int {
        minimumCellNumberOfFollowingMonth % 7
    }

    private var totalCellNumberOfFollowingCalendar: Int {
        followingFrontCellNumber == 0 ?
        minimumCellNumberOfFollowingMonth :
        minimumCellNumberOfFollowingMonth + (7 - followingFrontCellNumber)
    }
}
