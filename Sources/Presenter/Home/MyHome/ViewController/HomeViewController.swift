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

final class HomeViewController: BaseViewController {
    
    lazy var backgroundView = BackgroundView(frame: view.bounds)
    let viewModel: HomeViewModel
    var dateInfoIsHidden: Bool = false
    
    let homeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._20)
        label.attributedText = String.makeAtrributedString(
            name: "카리나",
            appendString: " 님과 함께",
            changeAppendStringSize: ._15,
            changeAppendStringWieght: .light,
            changeAppendStringColor: .white
        )
        label.textColor = .white
        return label
    }()
    
    lazy var alarmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AlarmButton"), for: .normal)
        button.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let ddayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._25)
        label.text = "D+254"
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
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "MoreButtonForOpen"), for: .normal)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var dateTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.cellId)
        tableView.rowHeight = 20
        tableView.isHidden = true
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        tableView.layer.borderWidth = 0.5
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundView = blurEffectView
        return tableView
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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, touch.view == self.view {
            self.dateInfoIsHidden = false
            self.moreButton.setImage(UIImage(named: "MoreButtonForOpen"), for: .normal)
            self.dateTableView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setAttributes()
        setUI()
        if viewModel.datePathList.isEmpty {
           setEmptyButton()
        }
    }
    
    func setEmptyButton() {
        let dateCoureRegisterButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("데이트 코스 기록하기", for: .normal)
            button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            button.tintColor = .designSystem(.mainYellow)
            button.backgroundColor = .designSystem(.mainYellow)?.withAlphaComponent(0.2)
            button.clipsToBounds = true
            button.layer.cornerRadius = 15
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            button.layer.borderWidth = 0.3
            button.setPreferredSymbolConfiguration(.init(pointSize: 11), forImageIn: .normal)
            button.setTitleColor(.designSystem(.mainYellow), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
            return button
        }()
        
        view.addSubview(dateCoureRegisterButton)
        dateCoureRegisterButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
        self.pathTableView.isHidden = true
    }
    
    @objc
    func alarmButtonTapped() {
        print("알람버튼이눌렸습니다")
    }
    
    @objc
    func moreButtonTapped() {
        dateInfoIsHidden.toggle()
        dateTableView.isHidden.toggle()
        moreButton.setImage(dateInfoIsHidden ? UIImage(named: "MoreButtonForClose") : UIImage(named: "MoreButtonForOpen"), for: .normal)
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        view.addSubview(homeTitle)
        view.addSubview(alarmButton)
        view.addSubview(ddayLabel)
        view.addSubview(nextDateLabel)
        view.addSubview(moreButton)
        view.addSubview(pathTableView)
        view.addSubview(dateTableView)
        dateTableView.dataSource = self
        pathTableView.delegate = self
        pathTableView.dataSource = self
        
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
            make.top.equalTo(homeTitle.snp.bottom)
            make.leading.equalTo(homeTitle.snp.leading)
        }
        
        nextDateLabel.snp.makeConstraints { make in
            make.top.equalTo(ddayLabel.snp.bottom).offset(10)
            make.leading.equalTo(homeTitle.snp.leading)
            make.height.equalTo(15)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(nextDateLabel.snp.centerY)
            make.leading.equalTo(nextDateLabel.snp.trailing).offset(5)
            make.size.equalTo(16)
        }
        dateTableView.snp.makeConstraints { make in
            make.leading.equalTo(homeTitle.snp.leading)
            make.top.equalTo(nextDateLabel.snp.bottom).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(viewModel.ddayDateList.count * 20 + 30)
        }
        
        pathTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            // MARK: - 하나의 cell높이(59), Header의 높이 43, Footer의 높이(60)에서 자연스럽게 10추가
            make.height.equalTo(viewModel.datePathList.count * 59 + 43 + 70)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCount = (tableView == dateTableView ? viewModel.ddayDateList.count : viewModel.datePathList.count)
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dateTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.cellId, for: indexPath) as? DateTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.dateData = viewModel.ddayDateList[indexPath.row]
            return cell
        } else if tableView == pathTableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PathTableViewCell.cellId, for: indexPath) as? PathTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            switch indexPath.row {
            case 0:
                cell.lineUpper.isHidden = true
                // MARK: - 코스가 하나일때 분기처리
                if viewModel.datePathList.count == 1 {
                    cell.lineLower.isHidden = true
                }
            case viewModel.datePathList.index(before: viewModel.datePathList.endIndex):
                cell.lineLower.isHidden = true
            default:
                cell.lineLower.isHidden = false
                cell.lineUpper.isHidden = false
            }
            
            cell.data = viewModel.datePathList[indexPath.row]
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == pathTableView {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PathTableHeader.cellId) as? PathTableHeader else { return UIView() }
            header.title.text = "포항 풀코스"
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
    func showPathActionSheet(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func showSettingActionSheet(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
