//
//  EditPlanetViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EditPlanetViewController: BaseViewController {
    var viewModel: EditPlanetViewModel

    init(viewModel: EditPlanetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var planetImageView = UIImageView()
    lazy var pageControl = UIPageControl()
    lazy var planetTextField = PlanetTextField(frame: .zero)
    lazy var alreadyHaveInvitationButton = AlreadyHaveInvitationButton(type: .system)
    lazy var nextButton = IntroButton(type: .system)
    lazy var conditionLabel = UILabel()

    // MARK: Properties

    var currentIndex: CGFloat = 0

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNofifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotifications()
    }

    private func bind() {

        viewModel.$planetImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageName in
                self?.planetImageView.image = UIImage(named: imageName)
            }
            .cancel(with: cancelBag)

        viewModel.$planetTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.nextButton.isEnabled = currentState == .good
            }
            .cancel(with: cancelBag)

        viewModel.$planetName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.planetTextField.text = name

                let label = UILabel()
                label.text = name
                label.sizeToFit()
                let newWidth: CGFloat = name.isEmpty ? 182 : (label.bounds.width + 30)

                UIView.animate(withDuration: 0.3, delay: 0) {
                    self?.planetTextField.snp.updateConstraints({ make in
                        make.width.equalTo(newWidth)
                    })
                    self?.planetTextField.setNeedsLayout()
                }
            }
            .cancel(with: cancelBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }

    @objc
    func nextButtonDidTapped() {
        viewModel.nextButtonDidTapped()
    }

    @objc
    func planetTextDidChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }

        viewModel.planetTextDidChanged(text)
    }
}

// MARK: - UI
extension EditPlanetViewController {

    private func setUI() {
        setAttributes()
        setLayout()
    }

    private func setAttributes() {

        setNavigationBar()
        navigationItem.title = "행성 이름 변경"
        navigationItem.backButtonTitle = ""

        conditionLabel.textColor = .designSystem(.grayC5C5C5)
        conditionLabel.font = .designSystem(weight: .regular, size: ._11)
        conditionLabel.text = "한글 + 영어 + 숫자  포함 8자 이내"

        planetTextField.addTarget(self, action: #selector(planetTextDidChanged), for: .editingChanged)
        nextButton.isEnabled = false
        nextButton.title = "다음"
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)
    }

    private func setLayout() {
        view.addSubview(planetImageView)
        view.addSubview(planetTextField)
        view.addSubview(nextButton)
        view.addSubview(conditionLabel)

        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.trailing.equalToSuperview().inset(93)
        }
        let constraint = planetImageView.heightAnchor.constraint(equalTo: planetImageView.widthAnchor, multiplier: 144 / 203)
        constraint.priority = UILayoutPriority(1000)
        constraint.isActive = true

        planetTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(320)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(182)
        }
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(planetTextField.snp.bottom).offset(8)
            make.centerX.equalTo(planetTextField)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    private func setNofifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.planetTextField.resignFirstResponder()
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.planetImageView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-100 - keyboardHeight)
                }
                self.planetTextField.snp.updateConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
                }
                self.nextButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight + Constants.Constraints.spaceBetweenkeyboardAndButton)
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {

        UIView.animate(withDuration: 1) {
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            }
            self.planetTextField.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(320)
            }
            self.nextButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension EditPlanetViewController {

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
