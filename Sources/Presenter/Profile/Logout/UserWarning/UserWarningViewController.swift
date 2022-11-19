//
//  UserWarningViewController.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

enum OutgoingType {
    case exitPlanet
    case membershipWithdrawal
}

final class UserWarningViewController: BaseViewController {
    var viewModel = UserWarningViewModel()
    var outgoingType: OutgoingType
    
    var myCancelBag = Set<AnyCancellable>()
    
    let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let warningPhraseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textAlignment = .center
        return label
    }()
    
    let subTitleLable: UILabel = {
        let label = UILabel()
        label.text = " 아래 내용을 확인해 주세요!"
        label.textAlignment = .center
        label.font = .designSystem(weight: .regular, size: ._15)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    let summaryPhraseView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.pinkF09BA1)?.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.designSystem(.white)?.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 0.3
        return view
    }()
    
    let warningPhraseLabel: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        return lable
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._13)
        label.textColor = .designSystem(.white)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("위 내용을 확인 후 동의합니다.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = .designSystem(.white)
        button.layer.borderWidth = 1
        button.tintColor = .designSystem(.mainYellow)
        return button
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .designSystem(.gray818181)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitleColor(.designSystem(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.isEnabled = false
        return button
    }()
    
    init(outgoingType: OutgoingType) {
        self.outgoingType = outgoingType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        viewModel.$isAgreed
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] revievedValue in
                self?.setAgreeButton(checked: revievedValue)
                self?.setNextButton(revievedValue)
            })
            .store(in: &myCancelBag)
        
        // output
        
    }
    
    private func setAgreeButton(checked: Bool) {
        agreeButton.layer.borderColor = checked ? .designSystem(.mainYellow) : .designSystem(.white)
        agreeButton.setImage(UIImage(systemName: checked ? "checkmark.circle.fill" : "circle"), for: .normal)
    }
    
    private func setNextButton(_ agreed: Bool) {
        nextButton.setTitleColor(agreed ? .black : .white, for: .normal)
        nextButton.backgroundColor = .designSystem(agreed ? .mainYellow : .gray818181)
        nextButton.isEnabled = agreed ? true : false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        setNavigation()
    }
    
    @objc
    func agreeButtonTapped() {
        viewModel.isAgreed.toggle()
    }
    
    @objc
    func nextButtonTapped() {
        print("다음으로 넘어갑니다")
        let nextVC = RecoverUserInfoViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - UI
extension UserWarningViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
        let userName = UserDefaults.standard.string(forKey: "name")
        let planetImageName = UserDefaults.standard.string(forKey: "planetImageString")
        guard let userName = userName else { return }
        guard let planetImageName = planetImageName else { return }
        let exitPlanetLabels = ["나와 메이트 둘 중 한명이라도 행성을 나가게되면, 지금까지 기록된 내용들이 전부 차단됩니다.", "행성에 기록된 자료는 30일까지 복구가 가능하며, 30일 이후는 보관된 자료들이 삭제가 됩니다.", "복구 시 기존의 기능들을 다시 정상적으로 사용할 수 있습니다"]
        let membershipWithdrawalLabels = ["나와 메이트 둘 중 한명이라도 회원탈퇴를 하게 되면, 행성이 바로 삭제됩니다.", "행성에 기록된 모든 기록들이 전부 삭제됩니다.", "행성에 기록된 자료는 복구가 불가능합니다."]
        
        nextButton.setTitle(outgoingType == .exitPlanet ? "행성나가기" : "회원탈퇴", for: .normal)
        summaryLabel.text = outgoingType == .exitPlanet ? "⭐행성이 없으면 앱의 모든기능을 사용할 수 없어요!\n⭐복구기간이 지나면 기록된 내용들이 사라져요!" :
                                                    "⭐회원탈퇴 시 행성이 사라져요!\n⭐행성에 기록된 모든 정보가 삭제 돼요!"
        summaryLabel.setLineSpacing(spacing: 10)
        warningPhraseLabel.attributedText = bulletPointList(strings: outgoingType == .exitPlanet ? exitPlanetLabels : membershipWithdrawalLabels)
        mainTitleLabel.text = outgoingType == .exitPlanet ? "\(userName)별을 나가실건가요?" : "회원을 탈퇴하시겠습니까?"
        titleImage.image = UIImage(named: planetImageName)
    }

    private func setNavigation() {
        self.title = outgoingType == .exitPlanet ? "행성 나가기" : "회원 탈퇴"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.gmarksans(weight: .bold, size: ._15)]
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        view.addSubview(agreeButton)
        view.addSubview(nextButton)
        view.addSubview(warningPhraseView)
        view.addSubview(titleImage)
        warningPhraseView.addSubview(mainTitleLabel)
        warningPhraseView.addSubview(subTitleLable)
        warningPhraseView.addSubview(summaryPhraseView)
        summaryPhraseView.addSubview(summaryLabel)
        warningPhraseView.addSubview(warningPhraseLabel)
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        
        titleImage.snp.makeConstraints { make in
            make.centerY.equalTo(warningPhraseView.snp.top)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(124)
        }
        
        warningPhraseView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(178)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(196)
        }
        
        warningPhraseLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryPhraseView.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(25)
        }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(subTitleLable.snp.top)
        }
        
        subTitleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(98)
            make.leading.trailing.equalToSuperview().inset(90)
            make.height.equalTo(18)
        }
        
        summaryPhraseView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(72)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(14)
        }

        agreeButton.snp.makeConstraints { make in
            make.top.equalTo(warningPhraseView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
    }
}

func bulletPointList(strings: [String]) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.headIndent = 15
    paragraphStyle.minimumLineHeight = 20
    paragraphStyle.maximumLineHeight = 20
    paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

    let stringAttributes = [
        NSAttributedString.Key.font: UIFont.designSystem(weight: .regular, size: ._13),
        NSAttributedString.Key.foregroundColor: UIColor.designSystem(.white),
        NSAttributedString.Key.paragraphStyle: paragraphStyle
    ]
    let string = strings.map({ "•\t\($0)" }).joined(separator: "\n\n")
    return NSAttributedString(string: string, attributes: stringAttributes)
}
