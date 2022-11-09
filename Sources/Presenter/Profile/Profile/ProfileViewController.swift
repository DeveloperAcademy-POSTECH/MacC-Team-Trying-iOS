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
    private let userSetting = ["닉네임 수정", "디데이 수정", "푸쉬 설정"]
    private let services = ["공지사항", "서비스 약관", "자주 묻는 질문"]
    
    var viewModel: ProfileViewModel
    
    private lazy var placeLabel = UILabel()
    
    private lazy var cityLabel = UILabel()
    
    private lazy var planetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var planetNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ProfileTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileTableViewHeaderView.identifier)
        tableView.register(ProfileTableViewActivityCell.self, forCellReuseIdentifier: ProfileTableViewActivityCell.identifier)
        tableView.register(ProfileTableViewServiceCell.self, forCellReuseIdentifier: ProfileTableViewServiceCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .designSystem(.gray818181)?.withAlphaComponent(0.8)
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()
    
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
                
                self.placeLabel.attributedText = string
            }
            .cancel(with: cancelBag)
        
        viewModel.$numberOfCities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] number in
                guard let self = self else { return }
                
                let firstString = NSAttributedString(string: "총", attributes: [.font: UIFont.gmarksans(weight: .light, size: ._15)])
                let secondString = NSAttributedString(string: " \(number)곳의", attributes: [.font: UIFont.gmarksans(weight: .bold, size: ._15)])
                let thirdString = NSAttributedString(string: " 도시에 방문했어요!", attributes: [.font: UIFont.gmarksans(weight: .light, size: ._15)])
                let string = NSMutableAttributedString()
                
                string.append(firstString)
                string.append(secondString)
                string.append(thirdString)
                
                self.cityLabel.attributedText = string
            }
            .cancel(with: cancelBag)
        
        viewModel.$planetImageName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageName in
                guard let self = self else { return }
                self.planetImageView.image = UIImage(named: imageName)
            }
            .cancel(with: cancelBag)
        
        viewModel.$planetName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.planetNameLabel.text = name
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
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        configureProfileNavigationBar(target: self, settingAction: #selector(settingButtonPressed(_:)))
        
        view.addSubviews(
            placeLabel,
            cityLabel,
            planetImageView,
            planetNameLabel,
            profileTableView
        )
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        planetNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(planetNameLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - User Interactions
extension ProfileViewController {
    @objc
    private func settingButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editPlanetNameAction = UIAlertAction(title: "행성 이름 변경", style: .default) { action in
            // TODO: logic 추가
        }
        let exitPlanetAction = UIAlertAction(title: "행성 나가기", style: .default) { action in
            // TODO: logic 추가
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(editPlanetNameAction)
        alertController.addAction(exitPlanetAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
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
                // TODO: 닉네임 수정
                break
            case 1:
                viewModel.pushToEditDayView()
            case 2:
                // TODO: 푸쉬 설정
                break
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
