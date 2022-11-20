//
//  HomeViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import Lottie

enum AddCourseFlowType: Int {
    // 과거에 계획을 안한경우 -> 계획,후기를 등록합니다0
    case addCourse = 0
    
    // 후기등록건드려야함
    // 과거인데 계획을 했을경우 -> 후기만 등록합니다
    // 미래인데 계획을 했을경우 -> 버튼 비활성화되어야함
    case registerReview
    
    // 수정버튼 건드려야함
    // 과거인데 계획이 되어있고 수정을 하는경우 -> 타이틀과 장소를 수정합니다0
    case editCourse
    
    // 미래인데 계획이 안되어있는 경우 -> 버튼 title을 바꿔야합니다0
    case addPlan
    
    // 수정버튼 건드려야함
    // 미래인데 계획이 되어있고 수정을 하는 경우 -> 타이틀하고 장소를 수정합니다0
    case editPlan
    
    // 이전에있던 addCourseFlowType Case
    case plan
    case record
}

final class HomeViewController: BaseViewController {
    
    var myCancelBag = Set<AnyCancellable>()
    let viewModel: HomeViewModel
    var dateInfoIsHidden: Bool = false
    var selectedDate: Date = YearMonthDayDate.today.asDate()
    
    let homeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._20)
        label.textColor = .white
        return label
    }()
    
    lazy var alarmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AlarmButton_notEmpty"), for: .normal)
        button.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let ddayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._25)
        label.textColor = .white
        return label
    }()
    
    let nextDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .light, size: ._13)
        label.text = "⭐️ 포항데이트 D-3"
        label.textColor = .white
        return label
    }()
    
    lazy var calendarView = CalendarView(today: .init(), frame: .init(origin: .zero, size: .init(width: DeviceInfo.screenWidth - 40, height: 0)))
    
    lazy var dateCoureRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .designSystem(.mainYellow)
        button.backgroundColor = .designSystem(.mainYellow)?.withAlphaComponent(0.2)
        button.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 0.3
        button.setPreferredSymbolConfiguration(.init(pointSize: 16), forImageIn: .normal)
        button.setTitleColor(.designSystem(.mainYellow), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        return button
    }()
    
    let pathTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PathTableViewCell.self, forCellReuseIdentifier: PathTableViewCell.cellId)
        tableView.register(PathTableHeader.self, forHeaderFooterViewReuseIdentifier: PathTableHeader.cellId)
        tableView.register(PathTableFooter.self, forHeaderFooterViewReuseIdentifier: PathTableFooter.cellId)
        tableView.rowHeight = 59
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 15
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .designSystem(.mainYellow)?.withAlphaComponent(0.2)
        tableView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        tableView.layer.borderWidth = 0.3
        return tableView
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
                guard let self = self else { return }
                guard let mate = receivedValue?.mate else { return }
                guard let dday = receivedValue?.planet?.dday else { return }
                self.homeTitle.attributedText = String.makeAtrributedString(
                    name: mate.name,
                    appendString: " 님과 함께",
                    changeAppendStringSize: ._15,
                    changeAppendStringWieght: .light,
                    changeAppendStringColor: .white
                )
                self.ddayLabel.text = "D+\(dday)"
            }
            .store(in: &myCancelBag)
        
        viewModel.$dateCalendarList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
                guard let self = self else { return }
                self.calendarView.scheduleList = receivedValue
            }
            .store(in: &myCancelBag)
        
        viewModel.$dateCourse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
                guard let self = self else { return }
                guard let receivedValue = receivedValue else { return }
                self.pathTableView.isHidden = false
                self.pathTableView.snp.makeConstraints { make in
                    make.top.equalTo(self.calendarView.snp.bottom).offset(10)
                    make.centerX.equalToSuperview()
                    make.leading.trailing.equalToSuperview().inset(20)
                    // MARK: - 하나의 cell높이(59), Header의 높이 43, Footer의 높이(60)에서 자연스럽게 10추가
                    make.height.equalTo(receivedValue.courseList.count * 59 + 43 + 70)
                    
                }
                self.pathTableView.reloadData()
            }
            .store(in: &myCancelBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        Task {
            let currentDateRange = getDateRange(currentDate: viewModel.selectedDate)
            try await viewModel.fetchUserInfo()
            try await viewModel.fetchDateRange(dateRange: currentDateRange)
            if viewModel.dateCalendarList.map({ $0.asDate() }).contains(viewModel.selectedDate) {
                try await viewModel.fetchSelectedDateCourse(selectedDate: viewModel.selectedDate.toString())
                self.calendarView.selectDateDirectly(self.selectedDate)
                self.dateCoureRegisterButton.isHidden = true
            } else {
                setRegisterButton(viewModel.selectedDate > Date() ? .addPlan : .addCourse)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setAttributes()
        setUI()
        
        Task {
            let currentDateRange = getDateRange(currentDate: viewModel.selectedDate)
            try await viewModel.fetchDateRange(dateRange: currentDateRange)
            if viewModel.dateCalendarList.map({ $0.asDate() }).contains(viewModel.selectedDate) {
                try await viewModel.fetchSelectedDateCourse(selectedDate: Date.currentDateString)
                self.dateCoureRegisterButton.isHidden = true
            } else {
                setRegisterButton(viewModel.selectedDate > Date() ? .addPlan : .addCourse)
            }
        }
    }
    
    @objc
    func alarmButtonTapped() {
        viewModel.pushToAlarmView()
    }
    
    @objc
    func inviteButtonTapped() {
        print("초대하기 버튼이 눌렸습니다")
    }
    
    @objc
    func registerButtonTapped(_ sender: UIButton) {
        guard let courseType = CourseFlowType(rawValue: sender.tag) else { return }
        viewModel.startAddCourseFlow(type: courseType)
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        view.addSubview(homeTitle)
        view.addSubview(alarmButton)
        view.addSubview(ddayLabel)
        view.addSubview(nextDateLabel)
        view.addSubview(pathTableView)
        view.addSubview(calendarView)
        view.addSubview(dateCoureRegisterButton)
        pathTableView.delegate = self
        pathTableView.dataSource = self
        calendarView.delegate = self
        
    }
    
    func setUI() {
        homeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(200)
            make.height.equalTo(25)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.top.equalTo(homeTitle.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
        
        ddayLabel.snp.makeConstraints { make in
            make.top.equalTo(homeTitle.snp.bottom).offset(5)
            make.leading.equalTo(homeTitle.snp.leading)
        }
        
        nextDateLabel.snp.makeConstraints { make in
            make.top.equalTo(ddayLabel.snp.bottom).offset(10)
            make.leading.equalTo(homeTitle.snp.leading)
            make.height.equalTo(15)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(nextDateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateCoureRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionCount = viewModel.dateCourse?.courseList.count else { return 0 }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PathTableViewCell.cellId, for: indexPath) as? PathTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        guard let course = viewModel.dateCourse else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.lineUpper.isHidden = true
            // MARK: - 코스가 하나일때 분기처리
            if course.courseList.count == 1 {
                cell.lineLower.isHidden = true
            }
        case course.courseList.index(before: course.courseList.endIndex):
            cell.lineLower.isHidden = true
        default:
            cell.lineLower.isHidden = false
            cell.lineUpper.isHidden = false
        }
        cell.data = viewModel.dateCourse?.courseList[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == pathTableView {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PathTableHeader.cellId) as? PathTableHeader else { return UIView() }
            header.title.text = viewModel.dateCourse?.courseTitle
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight = 43.0
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == pathTableView {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: PathTableFooter.cellId) as? PathTableFooter else { return UIView() }
            footer.delegate = self
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerHeight = 60.0
        return footerHeight
    }
}

extension HomeViewController: ActionSheetDelegate {
    func presentModifyViewController() {
        viewModel.startAddCourseFlow(type: self.viewModel.selectedDate > Date() ? .editPlan : .editCourse)
    }
    
    func presentRegisterReviewViewController() {
        if self.viewModel.selectedDate > Date() {
            let alert = UIAlertController(title: "안내", message: "미래의 계획은 후기를 등록할 수 없습니다", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "알겠습니다", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            viewModel.startAddCourseFlow(type: .registerReview)
        }
    }
    
    func showPathActionSheet(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func showSettingActionSheet(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

extension HomeViewController: CalendarViewDelegate {
    func changeCalendarPage(startDate: String, endDate: String) {
        Task {
            try await viewModel.fetchDateRange(
                dateRange: [
                    viewModel.selectedDate.month2Before.dateToString(),
                    viewModel.selectedDate.month2After.dateToString()
                ]
            )
        }
    }
    
    func switchCalendarButtonDidTapped() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 캘린더에서 특정날짜를 누르면 그 날짜를 input으로 넣어주는 delegate함수
    /// - Parameter date: 내가 누른 날짜
    func selectDate(_ date: Date?) {
        guard let date = date else { return }
        
        print(date)
        
        Task {
            self.viewModel.selectedDate = date
            // MARK: - 내가 누른 날짜가 처음에 조회한 데이트가 존재하는 날짜에 포함되어있는지를 판단
            // 데이트가 존재하지 않는날짜를 누르면 api자체를 호출하지 않게끔 하기 위한 분기처리 - 서버에서 데이터를 안주게 처리
            if viewModel.dateCalendarList.map({ $0.asDate() }).contains(date) {
                try await viewModel.fetchSelectedDateCourse(selectedDate: date.dateToString())
                self.dateCoureRegisterButton.isHidden = true
            } else {
                setRegisterButton(date > Date() ? .addPlan : .addCourse)
            }
        }
    }
    
    func scrollViewDidEndDecelerating() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 데이트가 없다면 데이트추가하기 버튼을 보여주는 분기처리 함수
    private func setRegisterButton(_ type: AddCourseFlowType) {
        switch type {
        case .addCourse:
            dateCoureRegisterButton.setTitle(" 별자리 등록하기", for: .normal)
            dateCoureRegisterButton.tag = 0
        case .addPlan:
            dateCoureRegisterButton.setTitle(" 데이트코스 계획하기", for: .normal)
            dateCoureRegisterButton.tag = 3
        default:
            break
        }
        
        self.dateCoureRegisterButton.isHidden = false
        self.pathTableView.isHidden = true
    }
    
    private func getDateRange(currentDate: Date) -> [String] {
        let beforeDate = currentDate.month2Before
        let nextDate = currentDate.month2After
        let beforeDateString = beforeDate.dateToString()
        let afterDateString = nextDate.dateToString()
        return [beforeDateString, afterDateString]
    }
}
