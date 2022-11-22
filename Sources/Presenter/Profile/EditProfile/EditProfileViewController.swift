//
//  EditProfileViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EditProfileViewController: BaseViewController {

    let viewModel: EditProfileViewModel

    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var stackView = UIStackView()

    lazy var containerView1 = UIView()
    lazy var emailSubtitleLabel = UILabel()
    lazy var emailLabel = UILabel()
    lazy var lineView1 = UIView()
    lazy var containerView2 = UIView()
    lazy var passwordSubTitleLabel = UILabel()
    lazy var passwordLabel = UILabel()
    lazy var lineView2 = UIView()
    lazy var passwordChangeButton = UIButton(type: .system)
    lazy var containerView3 = UIView()
    lazy var nicknameSubTitleLabel = UILabel()
    lazy var nicknameLabel = UILabel()
    lazy var lineView3 = UIView()
    lazy var nicknameChangeButton = UIButton(type: .system)
    lazy var logoutButton = UIButton(type: .system)
    lazy var deregisterButton = UIButton(type: .system)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchUserInformation()
    }

    private func bind() {
        viewModel.$nickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                self?.nicknameLabel.text = nickname
            }
            .cancel(with: cancelBag)

        viewModel.$socialAccount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSocialAccount in
                self?.passwordChangeButton.isHidden = isSocialAccount
                self?.emailLabel.text = isSocialAccount ? "소셜 로그인" : self?.viewModel.email
                self?.passwordLabel.text = isSocialAccount ? "소셜 로그인" : "**********"
            }
            .cancel(with: cancelBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

extension EditProfileViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }


    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.gmarksans(weight: .bold, size: ._17),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
    }

    private func setAttributes() {

        setNavigationBar()
        navigationItem.backButtonTitle = ""
        navigationItem.title = "내 정보 수정"

        emailSubtitleLabel.text = "이메일 아이디"
        emailLabel.text = "없음"
        emailLabel.font = .designSystem(weight: .regular, size: ._15)
        emailSubtitleLabel.font = .designSystem(weight: .regular, size: ._13)
        emailSubtitleLabel.textColor = .designSystem(.grayC5C5C5)
        lineView1.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)

        passwordSubTitleLabel.text = "비밀번호"
        passwordLabel.text = "**********"
        passwordLabel.font = .designSystem(weight: .regular, size: ._15)
        passwordSubTitleLabel.font = .designSystem(weight: .regular, size: ._13)
        passwordSubTitleLabel.textColor = .designSystem(.grayC5C5C5)
        lineView2.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        passwordChangeButton.layer.cornerRadius = 10
        passwordChangeButton.layer.borderColor = .designSystem(.mainYellow)
        passwordChangeButton.layer.borderWidth = 1
        passwordChangeButton.setTitle("변경", for: .normal)
        passwordChangeButton.setTitleColor(.designSystem(.mainYellow), for: .normal)
        passwordChangeButton.titleLabel?.font = .boldSystemFont(ofSize: 10)

        nicknameSubTitleLabel.text = "닉네임"
        nicknameLabel.text = "Asher"
        nicknameLabel.font = .designSystem(weight: .regular, size: ._15)
        nicknameSubTitleLabel.font = .designSystem(weight: .regular, size: ._13)
        nicknameSubTitleLabel.textColor = .designSystem(.grayC5C5C5)
        lineView3.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        nicknameChangeButton.layer.cornerRadius = 10
        nicknameChangeButton.layer.borderColor = .designSystem(.mainYellow)
        nicknameChangeButton.layer.borderWidth = 1
        nicknameChangeButton.setTitle("변경", for: .normal)
        nicknameChangeButton.setTitleColor(.designSystem(.mainYellow), for: .normal)
        nicknameChangeButton.titleLabel?.font = .boldSystemFont(ofSize: 10)

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20

        deregisterButton.setTitle("회원탈퇴", for: .normal)
        logoutButton.setTitle("로그아웃", for: .normal)
        deregisterButton.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        logoutButton.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        deregisterButton.setTitleColor(.designSystem(.grayC5C5C5), for: .normal)
        logoutButton.setTitleColor(.designSystem(.grayC5C5C5), for: .normal)
        passwordChangeButton.addTarget(self, action: #selector(passwordChangeButtonDidTapped), for: .touchUpInside)
        nicknameChangeButton.addTarget(self, action: #selector(nicknameChangeButtonDidTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTapped), for: .touchUpInside)
        deregisterButton.addTarget(self, action: #selector(deregisterButtonDidTapped), for: .touchUpInside)
    }

    private func setLayout() {
        view.addSubview(stackView)
        view.addSubview(logoutButton)
        view.addSubview(deregisterButton)
        stackView.addArrangedSubview(containerView1)
        stackView.addArrangedSubview(containerView2)
        stackView.addArrangedSubview(containerView3)

        containerView1.addSubview(emailSubtitleLabel)
        containerView1.addSubview(emailLabel)
        containerView1.addSubview(lineView1)

        containerView2.addSubview(passwordSubTitleLabel)
        containerView2.addSubview(passwordLabel)
        containerView2.addSubview(lineView2)
        containerView2.addSubview(passwordChangeButton)

        containerView3.addSubview(nicknameSubTitleLabel)
        containerView3.addSubview(nicknameLabel)
        containerView3.addSubview(lineView3)
        containerView3.addSubview(nicknameChangeButton)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        containerView1.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
        emailSubtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailSubtitleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(20)
        }
        lineView1.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        containerView2.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
        passwordSubTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordSubTitleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(20)
        }
        passwordChangeButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordSubTitleLabel).offset(4)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(49)
            make.height.equalTo(25)
        }
        lineView2.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        containerView3.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview()
        }
        nicknameSubTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameSubTitleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(20)
        }
        nicknameChangeButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameSubTitleLabel).offset(4)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(49)
            make.height.equalTo(25)
        }
        lineView3.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        deregisterButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(stackView.snp.bottom).offset(20)
        }
        logoutButton.snp.makeConstraints { make in
            make.trailing.equalTo(deregisterButton.snp.leading).offset(-20)
            make.centerY.equalTo(deregisterButton)
        }
    }

    @objc
    func nicknameChangeButtonDidTapped() {
        viewModel.coordinateToEditNicknameScene()
    }

    @objc
    func passwordChangeButtonDidTapped() {
        viewModel.passwordChangeButtonDidTapped()
    }

    @objc
    func logoutButtonDidTapped() {
        viewModel.logout()
    }

    @objc
    func deregisterButtonDidTapped() {
        viewModel.deregister()
    }
}
