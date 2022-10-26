//
//  NavigationBarConfigurable.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

protocol NavigationBarConfigurable: BaseViewController {
    /// 코스 등록 과정에서 지도가 있는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - dismissAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    ///   - pushAction: Next Button이 눌렸을 때 실행할 @objc 메소드
    func configureMapNavigationBar(target: Any, dismissAction: Selector, pushAction: Selector)
    
    /// 코스 등록 과정에서 장소를 검색할 수 있는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    ///   - doneAction: 완료 버튼이 눌렸을 때 실행할 @objc 메소드
    ///   - textEditingAction: TextField 편집 시 실행할 @objc 메소드
    func configureSearchNavigationBar(target: Any, popAction: Selector, doneAction: Selector, textEditingAction: Selector)
    
    /// 코스 등록 과정에서 코스 이름, 내용, 사진을 입력하는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    ///   - selectDateAction: 일정 선택 버튼이 눌렸을 때 실행할 @objc 메소드
    func configureCourseDetailNavigationBar(target: Any, popAction: Selector, selectDateAction: Selector)
}

extension NavigationBarConfigurable {
    func configureMapNavigationBar(target: Any, dismissAction: Selector, pushAction: Selector) {
        let dismissButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: Constants.Image.navBarDeleteButton), for: .normal)
            button.addTarget(target, action: dismissAction, for: .touchUpInside)
            return button
        }()
        
        let nextButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("어디를 방문하셨나요?", for: .normal)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            button.setTitleColor(.designSystem(.grayC5C5C5), for: .normal)
            button.backgroundColor = .designSystem(.black)
            button.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
            button.layer.cornerRadius = 22
            button.addTarget(target, action: pushAction, for: .touchUpInside)
            return button
        }()
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.77)
            make.height.equalTo(44)
        }
        
        let leftButtonItem = UIBarButtonItem(customView: dismissButton)
        let rightButtonItem = UIBarButtonItem(customView: nextButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func configureSearchNavigationBar(target: Any, popAction: Selector, doneAction: Selector, textEditingAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.chevron_left), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        let textFieldView: CustomTextField = {
            let textField = CustomTextField(type: .placeSearch)
            textField.addTarget(target, action: textEditingAction, for: .editingChanged)
            return textField
        }()
        let doneButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("완료", for: .normal)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.setTitleColor(.designSystem(.gray818181), for: .disabled)
            button.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
            button.addTarget(target, action: doneAction, for: .touchUpInside)
            return button
        }()
        
        textFieldView.addSubview(backButton)
        textFieldView.bounds = textFieldView.bounds.offsetBy(dx: 10, dy: 0)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }

        let leftButtonItem = UIBarButtonItem(customView: textFieldView)
        let rightButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func configureCourseDetailNavigationBar(target: Any, popAction: Selector, selectDateAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.chevron_left), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        let selectDateButton: SmallRoundButton = {
            let button = SmallRoundButton(type: .selectDate)
            button.addTarget(target, action: selectDateAction, for: .touchUpInside)
            return button
        }()
        
        let leftButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.titleView = selectDateButton
    }
}
