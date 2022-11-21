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
    private let services = ["공지사항", "서비스 약관", "자주 묻는 질문"]
    
    var viewModel: ProfileViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private lazy var profilePlanetView = ProfilePlanetView(type: .alone)
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchUserInformation()
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
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
        setButtonTarget()
        bind()
    }
}

// MARK: - UI
extension ProfileViewController: NavigationBarConfigurable {
    private func setUI() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        configureProfileNavigationBar(target: self, settingAction: #selector(settingButtonPressed(_:)))
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
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
            make.height.equalTo(290)
        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(profilePlanetView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(600)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - User Interactions
extension ProfileViewController {
    private func setButtonTarget() {
        switch self.profilePlanetView.type {
        case .noPlanet:
            profilePlanetView.enterPlanetButton.addTarget(self, action: #selector(enterPlanetButtonPressed(_:)), for: .touchUpInside)
            profilePlanetView.createPlanetButton.addTarget(self, action: #selector(createPlanetButtonPressed(_:)), for: .touchUpInside)
            
        case .alone:
            profilePlanetView.inviteMateButton.addTarget(self, action: #selector(inviteMateButtonPressed(_:)), for: .touchUpInside)
            
        case .couple:
            break
        }
    }
    
    @objc
    private func settingButtonPressed(_ sender: UIButton) {
        HapticManager.instance.selection()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editPlanetNameAction = UIAlertAction(title: "행성 이름 변경", style: .default) { [weak self] action in
            self?.viewModel.coordinateToEditPlanet()
        }
        let exitPlanetAction = UIAlertAction(title: "행성 나가기", style: .default) { [weak self] action in
            // TODO: logic 추가
            self?.viewModel.coordinateToExitPlanet()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(editPlanetNameAction)
        alertController.addAction(exitPlanetAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc
    private func enterPlanetButtonPressed(_ sender: UIButton) {
        // TODO: Enter Planet
        HapticManager.instance.selection()
    }
    
    @objc
    private func createPlanetButtonPressed(_ sender: UIButton) {
        // TODO: Create Planet
        HapticManager.instance.selection()
    }
    
    @objc
    private func inviteMateButtonPressed(_ sender: UIButton) {
        // TODO: Invite Mate
        HapticManager.instance.selection()
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
            return 3
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
            
            // FIXME: Data binding
            cell.numberOfConstellationLabel.text = "13개"
            cell.numberOfCourseLabel.text = "3개"
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
                viewModel.pushToEditDayView()
            case 2:
                viewModel.pushToEditNotificationView()
            default:
                break
                
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                // TODO: 공지사항
                break
            case 1:
                // TODO: 서비스 약관
                break
            case 2:
                // TODO: 자주 묻는 질문
                break
            default:
                break
                
            }
            
        default:
            break
        }
    }
}
