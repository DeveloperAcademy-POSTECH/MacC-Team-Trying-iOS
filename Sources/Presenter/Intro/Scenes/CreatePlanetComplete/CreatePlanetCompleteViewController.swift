//
//  CreatePlanetCompleteViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class CreatePlanetCompleteViewController: IntroBaseViewController<CreatePlanetCompleteViewModel> {

    lazy var backgroundView = BackgroundView(frame: view.bounds)
    lazy var celebrateLabel = UILabel()
    lazy var planetImageView = UIImageView()
    lazy var planetNameLabel = UILabel()
    lazy var invitationDescriptionLabel = UILabel()
    lazy var nextButton = IntroButton(type: .system)

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

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
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.backButtonTitle = ""
        navigationController?.setNavigationBarHidden(true, animated: false)

        let attributedText: NSMutableAttributedString = .init(string: "")
        attributedText.append(NSAttributedString(string: "행성 생성을\n", attributes: [
            .font: UIFont.designSystem(weight: .bold, size: ._20), .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: "축하드립니다! 🎉", attributes: [
            .font: UIFont.designSystem(weight: .bold, size: ._20), .foregroundColor: UIColor.white
        ]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: attributedText.length))

        celebrateLabel.attributedText = attributedText
        celebrateLabel.numberOfLines = 2
        
        invitationDescriptionLabel.font = .designSystem(weight: .regular, size: ._13)
        invitationDescriptionLabel.text = "메이트를 초대해서 같이 행성을 꾸며보세요!"

        nextButton.title = "확인"
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)
        
        planetNameLabel.font = .designSystem(weight: .bold, size: ._20)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(backgroundView)
        view.addSubview(celebrateLabel)
        view.addSubview(planetImageView)
        view.addSubview(planetNameLabel)
        view.addSubview(invitationDescriptionLabel)
        view.addSubview(nextButton)

        celebrateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(46)
            make.leading.equalToSuperview().offset(20)
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
        invitationDescriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension CreatePlanetCompleteViewController {
    @objc
    func nextButtonDidTapped() {
        viewModel.nextButtonDidTapped()
    }
}
