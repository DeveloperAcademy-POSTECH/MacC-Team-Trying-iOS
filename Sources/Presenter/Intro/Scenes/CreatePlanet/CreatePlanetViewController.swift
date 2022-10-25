//
//  CreatePlanetViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class CreatePlanetViewController: IntroBaseViewController<CreatePlanetViewModel> {

    lazy var backgroundView = BackgroundView(frame: view.bounds)
    lazy var collectionView = SelectPlanetCollectionView()
    lazy var pageControl = UIPageControl()
    lazy var planetTextField = PlanetTextField(frame: .zero)
    lazy var alreadyHaveInvitationButton = AlreadyHaveInvitationButton(type: .system)
    lazy var nextButton = IntroButton(type: .system)

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

    override func bind() {

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

    override func setAttribute() {
        super.setAttribute()

        navigationItem.hidesBackButton = true
        navigationItem.title = "행성생성"
        navigationItem.backButtonTitle = ""

        collectionView.delegate = self
        collectionView.dataSource = self

        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = viewModel.planets.count
        pageControl.currentPageIndicatorTintColor = .designSystem(.mainYellow)
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPage = 0
        pageControl.subviews.forEach { page in
            page.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }

        planetTextField.addTarget(self, action: #selector(planetTextDidChanged), for: .editingChanged)

        nextButton.title = "다음"
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)

        alreadyHaveInvitationButton.addTarget(self, action: #selector(alreadyHaveInvitationButtonDidTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(alreadyHaveInvitationButton)
        view.addSubview(planetTextField)
        view.addSubview(nextButton)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(-30)
        }
        planetTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(320)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(182)
        }
        alreadyHaveInvitationButton.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
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
                self.collectionView.snp.updateConstraints { make in
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
            self.collectionView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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

extension CreatePlanetViewController {

    @objc
    func nextButtonDidTapped() {
        viewModel.nextButtonDidTapped()
    }

    @objc
    func alreadyHaveInvitationButtonDidTapped() {
        viewModel.alreadyHaveInvitationButtonDidTapped()
    }

    @objc
    func planetTextDidChanged(_ sender: UITextField) {

        guard let text = sender.text else { return }

        viewModel.planetTextDidChanged(text)
    }
}

// MARK: - UICollectionViewDataSource
extension CreatePlanetViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.planets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PlanetCollectionViewCell.self, for: indexPath)
        cell.configure(with: viewModel.planets[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CreatePlanetViewController: UICollectionViewDelegate {

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let itemWidth: CGFloat = collectionView.bounds.width - SelectPlanetCollectionView.sideInset * 2
        let cellWidthIncludingSpacing = itemWidth + SelectPlanetCollectionView.spacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)

        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }

        if roundedIndex > currentIndex {
            roundedIndex = min(currentIndex + 1, CGFloat(viewModel.planets.count - 1))
        } else if index < currentIndex {
            roundedIndex = max(0, currentIndex - 1)
        }

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        currentIndex = roundedIndex
        viewModel.updateSelectedPlanet(index: Int(currentIndex))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let width: CGFloat = scrollView.contentOffset.x + SelectPlanetCollectionView.sideInset * 2
        let cellWidth: CGFloat = collectionView.bounds.width - SelectPlanetCollectionView.sideInset * 2 + SelectPlanetCollectionView.spacing
        let newPage = Int(width / cellWidth)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}
