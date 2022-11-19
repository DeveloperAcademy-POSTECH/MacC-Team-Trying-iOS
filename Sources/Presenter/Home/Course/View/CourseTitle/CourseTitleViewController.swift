//
//  CourseTitleViewController.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/05.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class CourseTitleViewController: BaseViewController {
    var type: CourseFlowType
    var viewModel: CourseTitleViewModel
    
    // MARK: UI Components
    private let descriptionLabel1: UILabel = {
        let label = UILabel()
        label.text = "생성할 코스의 이름을"
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .bold, size: ._20)
        return label
    }()
    private let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = "입력해주세요."
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .light, size: ._15)
        return label
    }()
    private lazy var titleTextField: CustomTextField = {
        let textField = CustomTextField(type: .courseTitle)
        textField.addTarget(self, action: #selector(dismissKeyboard(_:)), for: .editingDidEndOnExit)
        return textField
    }()
    private lazy var nextButton: MainButton = {
        let button = MainButton(type: .addCourse)
        button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        titleTextField.textPublisher()
            .assign(to: &self.viewModel.$title)
        
        // output
        viewModel.$title
            .sink { [weak self] courseTitle in
                guard let self = self else { return }
                self.nextButton.isEnabled = courseTitle.isEmpty ? false : true
            }
            .cancel(with: cancelBag)
    }
    
    init(type: CourseFlowType, viewModel: CourseTitleViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNofifications()
        presentKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotifications()
    }
}

// MARK: - UI
extension CourseTitleViewController: NavigationBarConfigurable {
    private func setUI() {
        configureRecordTitleNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
        setBackgroundGyroMotion()
        setNavigationBar()
        setLayout()
    }
    
    private func setNavigationBar() {
        switch self.type {
        case .addCourse:
            configureRecordTitleNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
            
        case .editCourse:
            configureRecordTitleNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
            
        case .addPlan:
            configurePlanTitleNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
            
        case .editPlan:
            configurePlanTitleNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
            
        default:
            break
        }
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(
            descriptionLabel1,
            descriptionLabel2,
            titleTextField,
            nextButton
        )
        
        descriptionLabel1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel2.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel1.snp.bottom).offset(5)
            make.leading.equalTo(descriptionLabel1)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel2.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func presentKeyboard() {
        titleTextField.becomeFirstResponder()
    }
}

// MARK: - User Interactions
extension CourseTitleViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
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
    
    @objc
    private func dismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        viewModel.pushToNextView()
    }
}
