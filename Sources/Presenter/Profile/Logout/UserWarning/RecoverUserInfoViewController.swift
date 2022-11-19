//
//  RecoverUserInfoViewController.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class RecoverUserInfoViewController: BaseViewController {
    
    let deletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("바로 삭제", for: .normal)
        button.setTitleColor(.designSystem(.red), for: .normal)
        button.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
        return button
    }()
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "\(UserDefaults.standard.string(forKey: "name") ?? "알수없는유저")별을 나왔습니다."
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .bold, size: ._20)
        return label
    }()

    let explainPhraseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()

    let explainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = bulletPointList(strings: ["행성이 없으면, 앱의 기능을 이용할 수 없습니다",
                                                         "나와 메이트 둘다 '복구하기'버튼을 클릭하여야 다시 모든 자료들이 복귀 됩니다.",
                                                         "자료는 30일 동안 보관되며, 이후 보관된 자료들이 삭제 됩니다"])
        label.numberOfLines = 0
        label.textColor = .designSystem(.white)
        return label
    }()

    let recoverInfoLabel: UILabel = {
        let label = UILabel()
        let currentDate = Date()
        let afterOneMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        label.text = "모든자료가 \(dateFormatter.string(from: afterOneMonthDate))에 삭제됩니다."
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.mainYellow)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.designSystem(.mainYellow)?.cgColor
        return label
    }()
    
    lazy var recoverButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .designSystem(.mainYellow)
        button.setTitle("복구 하기", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitleColor(.designSystem(.black), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.addTarget(self, action: #selector(recoverButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(deletButton)
        view.addSubviews(mainTitle)
        view.addSubviews(explainPhraseView)
        explainPhraseView.addSubviews(explainLabel)
        view.addSubviews(recoverInfoLabel)
        view.addSubviews(recoverButton)
        
        deletButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(67)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(18)
        }
        
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(deletButton.snp.bottom).offset(43)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        explainPhraseView.snp.makeConstraints { make in
            make.leading.equalTo(mainTitle.snp.leading)
            make.top.equalTo(mainTitle.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        recoverInfoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(123)
            make.height.equalTo(58)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        recoverButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(recoverInfoLabel)
            make.height.equalTo(58)
            make.top.equalTo(recoverInfoLabel.snp.bottom).offset(15)
        }
    }
    
    @objc
    func recoverButtonTapped() {
        recoverButton.setTitle("메이트의 복구를 기다리는 중 ...", for: .normal)
        recoverButton.setTitleColor(.designSystem(.white), for: .normal)
        recoverButton.backgroundColor = .designSystem(.gray818181)
        recoverButton.isEnabled = false
    }
}
