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
    var viewModel: RegisterCourseViewModel?
    
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
    private lazy var nextButton = MainButton(type: .next)
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
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
        setAttributes()
        setLayout()
        setInteractions()
        
        // FIXME: Tab bar hidden처리 앞 단에서 하기
        tabBarController?.tabBar.isHidden = true
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(
            imageCollectionView,
            courseTitleTextField,
            contentTextView,
            publicSwitch,
            nextButton,
            datePickerContainer
        )
        datePickerContainer.addSubview(datePicker)
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
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
            make.bottom.equalTo(nextButton.snp.top).offset(-15)
        }
        
        publicSwitch.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentTextView).offset(-15)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        (viewModel?.imageNames.count)! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.identifier, for: indexPath) as? AddImageCell else { return UICollectionViewCell() }
            cell.addImageButton.addTarget(self, action: #selector(presentPHPicker(_:)), for: .touchUpInside)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.placeImageView.image = UIImage(named: (viewModel?.imageNames[indexPath.row - 1])!)
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension RegisterCourseViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let selectedPhoto = results.first?.itemProvider
        
        if let selectedPhoto = selectedPhoto,
           selectedPhoto.canLoadObject(ofClass: UIImage.self) {
            selectedPhoto.loadObject(ofClass: UIImage.self) { image, _ in
                // TODO: Data binding with selected image
                // guard let selectedImage = image as? UIImage else { return }
            }
        }
    }
}

// MARK: - User Interactions
extension RegisterCourseViewController: UITextViewDelegate {
    private func setInteractions() {
//        guard let selectDateButton = navigationItem.titleView as? SmallRoundButton else { return }
//        selectDateButton.addTarget(self, action: #selector(datePickButtonPressed(_:)), for: .touchUpInside)
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
    
    /// TextView의 편집이 시작되었을 때, DatePicker가 활성화 되어있다면 dismiss하고, placeholder로 사용되던 text를 삭제합니다.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !datePicker.isHidden {
            dismissDatePicker()
        }

        if textView.text == "내용을 입력해 주세요." {
            textView.text = nil
        }
    }

    /// TextView의 편집이 끝났을 때, 텍스트가 없다면 placeholder로 사용될 text를 설정합니다.
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해 주세요."
        }
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        print("pop")
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
        
        if !datePicker.isHidden {
            dismissDatePicker()
        }
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
        let stringDate = formatter.string(from: sender.date)
        guard let selectDateButton = navigationItem.titleView as? SmallRoundButton else { return }
        
        DispatchQueue.main.async {
            selectDateButton.setTitle(stringDate, for: .normal)
            
            selectDateButton.snp.remakeConstraints { make in
                make.width.equalTo(144)
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
        // TODO: 사진 삭제
    }
    
    @objc
    private func presentPHPicker(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
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
