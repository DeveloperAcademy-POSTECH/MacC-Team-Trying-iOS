//
//  FindPlanetViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/26.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class FindPlanetViewController: IntroBaseViewController<FindPlanetViewModel> {

    lazy var backgroundView = BackgroundView(frame: view.bounds)
    lazy var titleLabels = IntroTitleLabels()
    lazy var codeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .invitationCode)
    lazy var planetImageView = UIImageView()
    lazy var planetNameLabel = UILabel()
    lazy var nextButton = IntroButton(type: .system)

    override func bind() {

        viewModel.$code
            .receive(on: DispatchQueue.main)
            .sink { [weak self] code in
                self?.codeTextFieldView.updateText(code)
            }
            .cancel(with: cancelBag)

        viewModel.$planetName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] planetName in
                self?.planetNameLabel.text = planetName
                self?.nextButton.title = "\(planetName) 궤도로 진입!"
            }
            .cancel(with: cancelBag)

        viewModel.$planetImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageName in
                self?.planetImageView.image = UIImage(named: imageName)
            }
            .cancel(with: cancelBag)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.nextButton.loading = isLoading
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.backButtonTitle = ""
        navigationItem.title = "코드입력"

        titleLabels.title = "환영합니다 🎉"
        titleLabels.subTitle = "우디행성을 발견했어요!"

        planetNameLabel.font = .designSystem(weight: .bold, size: ._20)

        codeTextFieldView.isUserInteractionEnabled = false
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(backgroundView)
        view.addSubview(titleLabels)
        view.addSubview(codeTextFieldView)
        view.addSubview(planetImageView)
        view.addSubview(planetNameLabel)
        view.addSubview(nextButton)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        codeTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(codeTextFieldView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(93)
            let height = (DeviceInfo.screenWidth - 93 * 2) * 144 / 203
            make.height.equalTo(height)
        }
        planetNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        view.layoutIfNeeded()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
//        self.codeTextFieldView.resignFirstResponder()
    }
}

extension FindPlanetViewController {
}
