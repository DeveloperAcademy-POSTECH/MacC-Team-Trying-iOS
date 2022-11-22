//
//  PathTableFooter.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class PathTableFooter: UITableViewHeaderFooterView {
    static let cellId = "PathTableFooter"
    
    weak var delegate: ActionSheetDelegate?
    
    private lazy var registerReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.setTitle("후기 등록", for: .normal)
        button.layer.borderColor = .designSystem(.mainYellow)
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.cornerRadius = 17
        // MARK: - SF Symbol크기 조절하는 메서드
        button.setPreferredSymbolConfiguration(.init(pointSize: 11), forImageIn: .normal)
        button.tintColor = .designSystem(.mainYellow)
        button.setTitleColor(.designSystem(.mainYellow), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingButton: UIButton = {
        let buttonImage = UIImage(named: "PathSettingButton")
        let button = UIButton(type: .custom)
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(registerReviewButton)
        addSubview(settingButton)
        registerReviewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(69)
            make.height.equalTo(34)
            make.centerY.equalToSuperview()
        }
        settingButton.snp.makeConstraints { make in
            make.leading.equalTo(registerReviewButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(34)
            make.centerY.equalToSuperview()
            
        }
    }
    
    @objc
    func settingButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modify = UIAlertAction(title: "별자리 수정하기", style: .default) { _ in
            self.delegate?.presentModifyViewController()
        }
        let delete = UIAlertAction(title: "별자리 삭제하기", style: .default) { _ in
            self.delegate?.deleteSelectedCourse()
            self.delegate?.reloadHomeView()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(modify)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        self.delegate?.showSettingActionSheet(alert: actionSheet)
    }
    
    @objc
    func registerButtonTapped() {
        self.delegate?.presentRegisterReviewViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
