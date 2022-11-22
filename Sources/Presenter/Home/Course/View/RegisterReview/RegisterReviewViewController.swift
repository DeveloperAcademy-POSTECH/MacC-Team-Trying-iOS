//
//  RegisterReviewViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import PhotosUI
import UIKit

import CancelBag
import SnapKit

final class RegisterReviewViewController: BaseViewController {
    var viewModel: RegisterReviewViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    private let contentView = UIView()
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let width = DeviceInfo.screenWidth / 3 - 20
        let height = width * 164 / 110
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }()
    private lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var contentTextView: CustomTextView = {
        let textView = CustomTextView()
        textView.delegate = self
        return textView
    }()
    private lazy var nextButton: MainButton = {
        let button = MainButton(type: .next)
        button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        viewModel.$reviewContent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if let text = text {
                    self.nextButton.isEnabled = text.isEmpty ? false : true
                } else {
                    self.nextButton.isEnabled = false
                }
            }
            .cancel(with: cancelBag)
        
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.imageCollectionView.reloadData()
            }
            .cancel(with: cancelBag)
    }
    
    init(viewModel: RegisterReviewViewModel) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setNofifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotifications()
    }
}

// MARK: - UI
extension RegisterReviewViewController: NavigationBarConfigurable {
    private func setUI() {
        configureCourseDetailNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
        setBackgroundGyroMotion()
        setLayout()
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        contentView.addSubviews(
            imageCollectionView,
            contentTextView,
            nextButton
        )
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            if UIDevice.current.hasNotch {
                make.height.equalTo(DeviceInfo.screenHeight * 0.1943)
            } else {
                make.height.equalTo(DeviceInfo.screenHeight * 0.24)
            }
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(DeviceInfo.screenHeight * 0.5105)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RegisterReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.identifier, for: indexPath) as? AddImageCell else { return UICollectionViewCell() }
            cell.addImageButton.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.placeImageView.image = viewModel.images[indexPath.row - 1]
            cell.deleteButton.tag = indexPath.row - 1
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        }
    }
}

// MARK: - User Interactions
extension RegisterReviewViewController: UITextViewDelegate {
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
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    animations: {
                        self.nextButton.snp.updateConstraints { make in
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight + Constants.Constraints.spaceBetweenkeyboardAndButton)
                        }
                        self.view.layoutIfNeeded()
                    }
                )
            }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.nextButton.snp.updateConstraints { make in
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                    }
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    /// UIButton의 터치가 아닐 때, dismissAllActivatedComponents() 메소드를 호출합니다.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view as? UIButton != nil { return false }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismissAllActivatedComponents()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.reviewContent = textView.text
    }
    
    /// TextView의 편집이 시작되었을 때, DatePicker가 활성화 되어있다면 dismiss하고, placeholder로 사용되던 text를 삭제합니다.
    /// 추가로 키보드 높이만큼 화면을 위로 이동시킵니다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "데이트 후기를 입력해 주세요." {
            textView.text = nil
        }

        let offset = CGPoint(x: 0, y: 180)
        scrollView.setContentOffset(offset, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                animations: {
                    self.contentTextView.snp.updateConstraints { make in
                        make.height.equalTo(DeviceInfo.screenHeight * 0.42)
                    }
                    self.view.layoutIfNeeded()
                }
            )
            
        }
    }

    /// TextView의 편집이 끝났을 때, 텍스트가 없다면 placeholder로 사용될 text를 설정합니다.
    /// 추가로 키보드 높이만큼 화면을 아래로 이동시킵니다.
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "데이트 후기를 입력해 주세요."
        }
        
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                animations: {
                    self.contentTextView.snp.updateConstraints { make in
                        make.height.equalTo(DeviceInfo.screenHeight * 0.5105)
                    }
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        viewModel.pushToNextView()
    }
    
    /// 화면 터치 시 활성화 되어있는 모든 것들을 dismiss합니다. (keyboard)
    @objc
    private func dismissAllActivatedComponents() {
        contentTextView.resignFirstResponder()
    }
    
    @objc
    private func deleteButtonPressed(_ sender: UIButton) {
        viewModel.deleteImage(sender.tag)
    }
    
    @objc
    private func pickImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.fixCannotMoveEditingBox()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension RegisterReviewViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.viewModel.addImage(image)
    }
}
