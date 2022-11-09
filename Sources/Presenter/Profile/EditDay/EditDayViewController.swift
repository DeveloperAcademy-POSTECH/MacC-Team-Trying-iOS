//
//  EditDayViewController.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/09.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EditDayViewController: BaseViewController {
    var viewModel: EditDayViewModel
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var doneButton: MainButton = {
        let button = MainButton(type: .done)
        button.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }
    
    init(viewModel: EditDayViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UI
extension EditDayViewController: NavigationBarConfigurable {
    private func setUI() {
        configureEditDayNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)))
        
        view.addSubviews(
            datePicker,
            doneButton
        )
        
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(180)
            make.center.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - User Interactions
extension EditDayViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func dateSelected(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    @objc
    private func doneButtonPressed(_ sender: UIButton) {
        // TODO: Update date
        viewModel.pop()
    }
}
