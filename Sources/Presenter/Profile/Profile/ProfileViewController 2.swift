//
//  ProfileViewController.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class ProfileViewController: BaseViewController {
    private let sections = ["활동내역", "회원설정", "고객센터"]
    private let userSetting = ["내 정보 수정", "디데이 수정", "푸쉬 설정"]
    private let services = ["서비스 약관", "1대1 문의"]
    
    var viewModel: ProfileViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private lazy var profilePlanetView = ProfilePlanetView()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ProfileTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileTableViewHeaderView.identifier)
        tableView.register(ProfileTableViewActivityCell.self, forCellReuseIdentifier: ProfileTableViewActivityCell.identifier)
        tableView.register(ProfileTableViewServiceCell.self, forCellReuseIdentifier: ProfileTableViewServiceCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .designSystem(.gray818181)?.withAlphaComponent(0.8)
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()
    
    private lazy var blackBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.black)?.withAlphaComponent(0.6)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackBackgroundViewPressed(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    private lazy var editDateView: EditDateView = {
        let view = EditDateView()
        view.datePicker.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        view.dismissButton.addTarget(self, action: #selector(editDateDismissButtonPressed(_:)), for: .touchUpInside)
        view.doneButton.addTarget(self, action: #selector(editDateDoneButtonPressed(_:)), for: .touchUpInside)
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchUserInformation()
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        viewModel.$planetImageName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageName in
                guard let self = self else { return }
                self.profilePlanetView.planetImageView.image = UIImage(named: imageName)
            }
            .cancel(with: cancelBag)
        
        viewModel.$planetName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.profilePlanetView.planetNameLabel.text = name
            }
            .cancel(with: cancelBag)
        
        /*
        viewModel.$numberOfPlaces
            .receive(on: DispatchQueue.main)
            .sink { [weak self] number in
                guard let self = self else { return }
                
                let firstString = NSAttributedString(string: "우리는", attributes: [.font: UIFont.gmarksans(weight: .light, size: ._15)])
                let secondString = NSAttributedString(string: " \(number)개의", attributes: [.font: UIFont.gmarksans(weight: .bold, size: ._15)])
                let thirdString = NSAttributedString(string: " 장소에 방문했어요!", attributes: [.font: UIFont.gmarksans(weight: .light, size: ._15)])
                let string = NSMutableAttributedString()
                
                string.append(firstString)
                string.append(secondString)
                string.append(thirdString)
                
                self.profilePlanetView.placeLabel.attributedText = string
            }
            .cancel(with: cancelBag)
         */
        
        viewModel.$activities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] numberOfCourses, numberOfLikedCourses in
                guard let self = self,
                      let activityCell = self.profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableViewActivityCell else { return }
                
                activityCell.numberOfConstellationLabel.text = "\(numberOfCourses)개"
                activityCell.numberOfLikedCourseLabel.text = "\(numberOfLikedCourses)개"
            }
            .cancel(with: cancelBag)
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension ProfileViewController: NavigationBarConfigurable {
    private func setUI() {
        configureProfileNavigationBar(target: self, settingAction: #selector(settingButtonPressed(_:)))
        setBackgroundGyroMotion()
        setLayout()
        navigationItem.backButtonTitle = ""
    }
    
    private func setLayout() {
        view.addSubviews(
            scrollView,
            editDateView
        )
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        contentView.addSubviews(
            profilePlanetView,
            profileTableView
        )

        profilePlanetView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(profilePlanetView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(600)
            make.bottom.equalToSuperview()
        }

        editDateView.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview().inset(30)
            make.height.equalTo(editDateView.height)
            make.bottom.equalToSuperview().inset(-editDateView.height)
        }
    }
    
    private func hideEditDateView() {
        DispatchQueue.main.async {
            self.editDateView.hide()
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
            
            self.blackBackgroundView.removeFromSuperview()
        }
        
        self.toggleSettingButtonEnable()
    }
    
    private func presentEditDateView() {
        self.view.addSubview(self.blackBackgroundView)
        self.blackBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.bringSubviewToFront(self.editDateView)
        DispatchQueue.main.async {
            self.editDateView.present()
            
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
        
        self.toggleSettingButtonEnable()
    }
}

// MARK: - User Interactions
extension ProfileViewController {
    @objc
    private func settingButtonPressed(_ sender: UIButton) {
        HapticManager.instance.selection()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editPlanetNameAction = UIAlertAction(title: "행성 이름 변경", style: .default) { [weak self] _ in
            self?.viewModel.coordinateToEditPlanet()
        }
        let exitPlanetAction = UIAlertAction(title: "행성 나가기", style: .default) { [weak self] _ in
            self?.viewModel.coordinateToExitPlanet()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(editPlanetNameAction)
        alertController.addAction(exitPlanetAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc
    private func dateSelected(_ sender: UIDatePicker) {
        self.viewModel.date = sender.date.dateToString()
    }
    
    @objc
    private func editDateDismissButtonPressed(_ sender: UIButton) {
        self.hideEditDateView()
    }
    
    @objc
    private func editDateDoneButtonPressed(_ sender: UIButton) {
        self.viewModel.editDate()
        self.hideEditDateView()
    }
    
    @objc
    private func blackBackgroundViewPressed(_ sender: UITapGestureRecognizer) {
        self.hideEditDateView()
    }
    
    private func toggleSettingButtonEnable() {
        guard let settingButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
        settingButton.isEnabled.toggle()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return -1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileTableViewHeaderView.identifier) as? ProfileTableViewHeaderView else { return UIView() }
        headerView.titleLabel.text = sections[section]
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewActivityCell.identifier, for: indexPath)
                    as? ProfileTableViewActivityCell else { return UITableViewCell() }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewServiceCell.identifier, for: indexPath) as? ProfileTableViewServiceCell else { return UITableViewCell() }
            cell.serviceLabel.text = userSetting[indexPath.row]
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewServiceCell.identifier, for: indexPath) as? ProfileTableViewServiceCell else { return UITableViewCell() }
            cell.serviceLabel.text = services[indexPath.row]
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 56
        case 2:
            return 56
        default:
            return -1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
            
        case 1:
            switch indexPath.row {
            case 0:
                viewModel.editProfileButtonDidTapped()
            case 1:
                self.presentEditDateView()
            case 2:
                viewModel.pushToEditNotificationView()
            default:
                break
                
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                self.viewModel.pushToServiceTermView()
            case 1:
                self.viewModel.presentKakaoInquiry()
            default:
                break
            }
            
        default:
            break
        }
    }
}
