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
    /// 데이트 기록 과정에서 Course Title을 입력하는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configureRecordTitleNavigationBar(target: Any, popAction: Selector)
    
    /// 데이트 계획 과정에서 Course Title을 입력하는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configurePlanTitleNavigationBar(target: Any, popAction: Selector)
    
    /// 데이트 기록 과정에서 지도가 있는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - dismissAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    ///   - pushAction: Next Button이 눌렸을 때 실행할 @objc 메소드
    func configureRecordMapNavigationBar(target: Any, dismissAction: Selector, pushAction: Selector)
    
    /// 데이트 계획 과정에서 지도가 있는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - dismissAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    ///   - pushAction: Next Button이 눌렸을 때 실행할 @objc 메소드
    func configurePlanMapNavigationNar(target: Any, dismissAction: Selector, pushAction: Selector)
    
    /// 코스 등록 과정에서 장소를 검색할 수 있는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    ///   - mapAction: 지도 버튼이 눌렸을 때 실행할 @objc 메소드
    ///   - textEditingAction: TextField 편집 시 실행할 @objc 메소드
    func configureSearchNavigationBar(target: Any, popAction: Selector, mapAction: Selector, textEditingAction: Selector)
    
    /// 데이트 기록 과정에서 사진, 데이트 후기를 입력하는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configureCourseDetailNavigationBar(target: Any, popAction: Selector)
    
    /// 프로필 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - settingAction: 설정 버튼이 눌렸을 때 실행할 @objc 메소드
    func configureProfileNavigationBar(target: Any, settingAction: Selector)
    
    /// 디데이 수정을 하는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - popAction: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configureEditDayNavigationBar(target: Any, popAction: Selector)
}

extension NavigationBarConfigurable {
    func configureRecordTitleNavigationBar(target: Any, popAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.navBackButton), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "코스 기록"
            label.textColor = .designSystem(.white)
            label.font = .gmarksans(weight: .bold, size: ._15)
            return label
        }()
        let leftButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.titleView = titleLabel
    }
    
    func configurePlanTitleNavigationBar(target: Any, popAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.navBackButton), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "코스 계획"
            label.textColor = .designSystem(.white)
            label.font = .gmarksans(weight: .bold, size: ._15)
            return label
        }()
        
        let leftButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.titleView = titleLabel
    }
    
    func configureRecordMapNavigationBar(target: Any, dismissAction: Selector, pushAction: Selector) {
        let dismissButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: Constants.Image.navBarDeleteButton), for: .normal)
            button.addTarget(target, action: dismissAction, for: .touchUpInside)
            return button
        }()
        
        let nextButton: UIButton = {
            var configuration = UIButton.Configuration.filled()
            var attributedString = AttributedString.init("어디를 방문하셨나요?")
            attributedString.font = .designSystem(weight: .regular, size: ._15)
            configuration.attributedTitle = attributedString
            configuration.titleAlignment = .leading
            configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 110)
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .medium)
            let image = UIImage(systemName: Constants.Image.magnifyingglass, withConfiguration: symbolConfiguration)
            configuration.image = image
            configuration.imagePlacement = .leading
            configuration.imagePadding = 5
            configuration.cornerStyle = .capsule
            configuration.baseBackgroundColor = .designSystem(.black)
            configuration.baseForegroundColor = .designSystem(.grayC5C5C5)
            let button = UIButton(configuration: configuration)
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
    
    func configurePlanMapNavigationNar(target: Any, dismissAction: Selector, pushAction: Selector) {
        let dismissButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: Constants.Image.navBarDeleteButton), for: .normal)
            button.addTarget(target, action: dismissAction, for: .touchUpInside)
            return button
        }()
        
        let nextButton: UIButton = {
            var configuration = UIButton.Configuration.filled()
            var attributedString = AttributedString.init("어디를 방문하실 계획인가요??")
            attributedString.font = .designSystem(weight: .regular, size: ._15)
            configuration.attributedTitle = attributedString
            configuration.titleAlignment = .leading
            configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 110)
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .medium)
            let image = UIImage(systemName: Constants.Image.magnifyingglass, withConfiguration: symbolConfiguration)
            configuration.image = image
            configuration.imagePlacement = .leading
            configuration.imagePadding = 5
            configuration.cornerStyle = .capsule
            configuration.baseBackgroundColor = .designSystem(.black)
            configuration.baseForegroundColor = .designSystem(.grayC5C5C5)
            let button = UIButton(configuration: configuration)
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
    
    func configureSearchNavigationBar(target: Any, popAction: Selector, mapAction: Selector, textEditingAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.navBackButton), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        let textFieldView: CustomTextField = {
            let textField = CustomTextField(type: .placeSearch)
            textField.addTarget(target, action: textEditingAction, for: .editingChanged)
            return textField
        }()
        let mapButton: UIButton = {
            let button = UIButton(type: .custom)
            let configuration = UIImage.SymbolConfiguration(pointSize: 20)
            let mapImage = UIImage(systemName: Constants.Image.map, withConfiguration: configuration)
            button.setImage(mapImage, for: .normal)
            button.tintColor = .designSystem(.white)
            button.addTarget(target, action: mapAction, for: .touchUpInside)
            return button
        }()
        
        textFieldView.addSubview(backButton)
        textFieldView.bounds = textFieldView.bounds.offsetBy(dx: 10, dy: 0)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }

        let leftButtonItem = UIBarButtonItem(customView: textFieldView)
        let rightButtonItem = UIBarButtonItem(customView: mapButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func configureCourseDetailNavigationBar(target: Any, popAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.navBackButton), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        
        let leftButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    func configureProfileNavigationBar(target: Any, settingAction: Selector) {
        let titleView: UILabel = {
            let label = UILabel()
            label.text = "My"
            label.textColor = .designSystem(.white)
            label.font = .gmarksans(weight: .bold, size: ._25)
            return label
        }()
        /*
        let dayLabel: UILabel = {
            let label = UILabel()
            label.text = "D+\(day)"
            label.font = .gmarksans(weight: .bold, size: ._15)
            label.textColor = .designSystem(.white)
            return label
        }()
        */
        let settingButton: UIButton = {
            let button = UIButton(type: .custom)
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
            let image = UIImage(systemName: Constants.Image.setting, withConfiguration: configuration)
            button.setImage(image, for: .normal)
            button.tintColor = .designSystem(.white)
            button.addTarget(target, action: settingAction, for: .touchUpInside)
            return button
        }()

        let leftTitleItem = UIBarButtonItem(customView: titleView)
        // let dayLabelButtonItem = UIBarButtonItem(customView: dayLabel)
        let settingButtonItem = UIBarButtonItem(customView: settingButton)
        
        navigationItem.leftBarButtonItem = leftTitleItem
        navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    func configureEditDayNavigationBar(target: Any, popAction: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.navBackButton), for: .normal)
            button.addTarget(target, action: popAction, for: .touchUpInside)
            return button
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.attributedText = NSAttributedString(string: "디데이 수정", attributes: [.font: UIFont.gmarksans(weight: .bold, size: ._15)])
            label.textColor = .designSystem(.white)
            return label
        }()
        
        let leftButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.titleView = titleLabel
    }
}
