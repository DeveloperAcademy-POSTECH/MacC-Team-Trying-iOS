//
//  WaitingInvitationViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class WaitingInvitationViewController: IntroBaseViewController<WaitingInvitationViewModel> {

    lazy var backgroundView = BackgroundView(frame: view.bounds)
    lazy var currentProgressView = CurrentSignUpProgressView()
    lazy var planetImageView = UIImageView()
    lazy var planetNameLabel = UILabel()
    lazy var mateLabel = UILabel()
    lazy var invitationCodeButton = InvitationCodeButton(type: .system)
    lazy var deleteButton = UIButton(type: .system)

    override func bind() {

        viewModel.$selectedPlanet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] planet in
                self?.planetImageView.image = .init(named: planet)
            }
            .cancel(with: cancelBag)

        viewModel.$planetName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] planetName in
                self?.planetNameLabel.text = planetName
            }
            .cancel(with: cancelBag)

        viewModel.$code
            .receive(on: DispatchQueue.main)
            .sink { [weak self] code in
                self?.invitationCodeButton.invitationCode = code
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        deleteButton.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
        deleteButton.setTitle("행성삭제", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)

        setNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
        navigationItem.hidesBackButton = true
        navigationItem.title = "가입 진행 중"

        mateLabel.text = "메이트를 초대해서 같이 행성을 꾸며보세요!"
        mateLabel.font = UIFont.designSystem(weight: .regular, size: ._13)

        planetNameLabel.font = UIFont.designSystem(weight: .bold, size: ._20)
        invitationCodeButton.addTarget(self, action: #selector(invitationCodeButtonDidTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(backgroundView)
        view.addSubview(currentProgressView)
        view.addSubview(planetImageView)
        view.addSubview(planetNameLabel)
        view.addSubview(mateLabel)
        view.addSubview(invitationCodeButton)

        currentProgressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        planetImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-55)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(93)
            let height = (DeviceInfo.screenWidth - 93 * 2) * 144 / 203
            make.height.equalTo(height)
        }
        planetNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        mateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(invitationCodeButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        invitationCodeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        view.layoutIfNeeded()
    }
}

extension WaitingInvitationViewController {

    @objc
    func invitationCodeButtonDidTapped() {
        UIPasteboard.general.string = viewModel.code
        ToastFactory.show(message: "코드가 복사되었어요!", type: .success)
    }

    @objc
    func deleteButtonDidTapped() {
        self.present(alertController(), animated: true, completion: nil)
    }

    private func alertController() -> UIAlertController {
        let controller = UIAlertController(title: "행성 삭제", message: "정말 정말로 행성을 삭제할까요?", preferredStyle: .alert)

        let getAuthAction = UIAlertAction(
            title: "삭제할래요",
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel.deletePlanet()
            }
        )
        let cancelAction = UIAlertAction(
            title: "아니요",
            style: .cancel
        )
        controller.addAction(getAuthAction)
        controller.addAction(cancelAction)

        return controller
    }

}

extension WaitingInvitationViewController {

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
}
