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
    ///   - action: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configureMapNavigationBar(target: Any?, action: Selector?)
    
    /// 코스 등록 과정에서 장소를 검색할 수 있는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - action: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configureSearchNavigationBar(target: Any?, action: Selector)
    
    /// 코스 등록 과정에서 코스 이름, 내용, 사진을 입력하는 화면에서 사용되는 Navigation Bar를 설정합니다.
    /// - Parameters:
    ///   - target: Target
    ///   - action: Back Button이 눌렸을 때 실행할 @objc 메소드
    func configureCourseDetailNavigationBar(target: Any?, action: Selector?)
}

extension NavigationBarConfigurable {
    func configureMapNavigationBar(target: Any?, action: Selector?) {
        let backButton = UIBarButtonItem(
            image: UIImage(named: Constants.Image.x_mark)?
                .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)),
            style: .plain,
            target: target,
            action: action
        )
        let titleView = CustomTextField(type: .placeSearch)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleView
    }
    
    func configureSearchNavigationBar(target: Any?, action: Selector) {
        let backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: Constants.Image.chevron_left), for: .normal)
            button.addTarget(target, action: action, for: .touchUpInside)
            return button
        }()
        let textFieldView = CustomTextField(type: .placeSearch)
        let doneButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("완료", for: .normal)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.setTitleColor(.designSystem(.gray818181), for: .disabled)
            button.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
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
    
    func configureCourseDetailNavigationBar(target: Any?, action: Selector?) {
        let backButton = UIBarButtonItem(
            image: UIImage(named: Constants.Image.chevron_left),
            style: .plain,
            target: target,
            action: action
        )
        let titleView = SmallRoundButton(type: .selectDate)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleView
    }
}
