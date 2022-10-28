//
//  RegisterCourseViewController.swift
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

final class RegisterCourseViewController: BaseViewController {
    var viewModel: RegisterCourseViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    private let contentView = UIView()
    private lazy var datePickerContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .designSystem(.gray3B3C46)
        view.layer.cornerRadius = 15
        return view
    }()
    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .inline
        setMaxMinDate(&datePicker, max: 1000, min: -1000)
        datePicker.backgroundColor = .clear
        datePicker.layer.cornerRadius = 15
        datePicker.layer.masksToBounds = true
        datePicker.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        return datePicker
    }()
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
    private lazy var courseTitleTextField: CustomTextField = {
        let textField = CustomTextField(type: .courseTitle)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return textField
    }()
    private lazy var contentTextView: CustomTextView = {
        let textView = CustomTextView()
        textView.delegate = self
        return textView
    }()
    private lazy var publicSwitch = CustomToggleButton()
    private lazy var nextButton: MainButton = {
        let button = MainButton(type: .next)
        button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.imageCollectionView.reloadData()
            }
            .cancel(with: cancelBag)
    }
    
    init(viewModel: RegisterCourseViewModel) {
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
extension RegisterCourseViewController: NavigationBarConfigurable {
    private func setUI() {
        configureCourseDetailNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)), selectDateAction: #selector(selectDateButtonPressed(_:)))
        setLayout()
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        datePickerContainer.addSubview(datePicker)
        contentView.addSubviews(
            imageCollectionView,
            courseTitleTextField,
            contentTextView,
            publicSwitch,
            nextButton,
            datePickerContainer
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
        
        courseTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(370)
        }
        
        publicSwitch.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentTextView).offset(-15)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        datePickerContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RegisterCourseViewController: UICollectionViewDataSource {
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
extension RegisterCourseViewController: UITextViewDelegate {
    /// UIButton의 터치가 아닐 때, dismissAllActivatedComponents() 메소드를 호출합니다.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view as? UIButton != nil { return false }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismissAllActivatedComponents()
        }
        return true
    }
    
    /// TextView의 편집이 시작되었을 때, DatePicker가 활성화 되어있다면 dismiss하고, placeholder로 사용되던 text를 삭제합니다.
    /// 추가로 키보드 높이만큼 화면을 위로 이동시킵니다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !datePicker.isHidden {
            dismissDatePicker()
        }

        if textView.text == "내용을 입력해 주세요." {
            textView.text = nil
        }

        let offset = CGPoint(x: 0, y: 245)
        scrollView.setContentOffset(offset, animated: true)
    }

    /// TextView의 편집이 끝났을 때, 텍스트가 없다면 placeholder로 사용될 text를 설정합니다.
    /// 추가로 키보드 높이만큼 화면을 아래로 이동시킵니다.
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해 주세요."
        }
        
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        viewModel.pushToAddCourseCompleteView(courseTitle: courseTitleTextField.text!, courseContent: contentTextView.text, isPublic: publicSwitch.isOn)
    }
    
    /// TextField의 편집이 시작될 때, DatePicker가 활성화 되어있다면 dismiss합니다.
    @objc
    private func textFieldDidBeginEditing(_ sender: UITextField) {
        if !datePicker.isHidden {
            dismissDatePicker()
        }
    }
    
    /// 화면 터치 시 활성화 되어있는 모든 것들을 dismiss합니다. (keyboard, UIDatePicker)
    @objc
    private func dismissAllActivatedComponents() {
        courseTitleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
    }
    
    /// 일정 선택 버튼이 눌렸을 때, 키보드를 dismiss하고 DatePicker를 present하거나 dismiss합니다.
    @objc
    private func selectDateButtonPressed(_ sender: UIButton) {
        courseTitleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        datePicker.isHidden ? presentDatePicker() : dismissDatePicker()
    }
    
    /// DatePicker를 보여줍니다.
    private func presentDatePicker() {
        self.datePicker.fadeIn(0.3)
        self.datePickerContainer.fadeIn(0.3)
    }
    
    /// DatePicker를 숨깁니다.
    private func dismissDatePicker() {
        self.datePicker.fadeOut(0.3)
        self.datePickerContainer.fadeOut(0.3)
    }
    
    @objc
    private func dateSelected(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy - MM - dd (E)"
        formatter.locale = Locale(identifier: "ko")
        let stringDate = formatter.string(from: sender.date)
        guard let selectDateButton = navigationItem.titleView as? SmallRoundButton else { return }
        
        DispatchQueue.main.async {
            selectDateButton.setTitle(stringDate, for: .normal)
            
            selectDateButton.snp.remakeConstraints { make in
                make.width.equalTo(150)
            }
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    self.navigationController?.navigationBar.layoutIfNeeded()
                }
            )
        }
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
extension RegisterCourseViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.viewModel.addImage(image)
    }
}

// MARK: - Helper Methods
extension RegisterCourseViewController {
    /// DatePicker에서 선택할 수 있는 최대, 최소 날짜를 설정합니다.
    /// - Parameters:
    ///   - datePicker: 설정할 DatePicker를 Reference로 전달합니다.
    ///   - max: 현재 기준으로 몇일 후 까지 선택 가능하게 할지 정합니다.
    ///   - min: 현재 기준으로 몇일 전 까지 선택 가능하게 할지 정합니다.
    private func setMaxMinDate(_ datePicker: inout UIDatePicker, max: Int, min: Int) {
        var components = DateComponents()
        components.day = max
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        components.day = min
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
    }
}
