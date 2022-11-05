//
//  AddCourseCompleteViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import Lottie
import SnapKit
import CoreLocation

final class AddCourseCompleteViewController: BaseViewController {
    private let type: AddCourseFlowType
    var viewModel: AddCourseCompleteViewModel
    
    private lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString()
        let firstString = NSAttributedString(string: "새로운 별자리가", attributes: [.font: UIFont.gmarksans(weight: .light, size: ._15)])
        let secondString = NSAttributedString(string: type == .record ? "\n기록" : "\n계획", attributes: [.font: UIFont.gmarksans(weight: .bold, size: ._15)])
        let thirdString = NSAttributedString(string: "됐습니다!", attributes: [.font: UIFont.gmarksans(weight: .medium, size: ._15)])
        attributedString.append(firstString)
        attributedString.append(secondString)
        attributedString.append(thirdString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    private lazy var starLottie: LottieAnimationView = {
        let lottie = LottieAnimationView(name: Constants.Lottie.starLottie)
        lottie.contentMode = .scaleAspectFit
        lottie.animationSpeed = 0.5
        lottie.loopMode = .loop
        lottie.play()
        return lottie
    }()
    private lazy var constellationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = viewModel.makeStars(places: viewModel.places)
        return imageView
    }()
    private lazy var courseTitleLabel: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
        label.textColor = .designSystem(.mainYellow)
        label.font = .designSystem(weight: .bold, size: ._13)
        label.backgroundColor = .designSystem(.black)
        label.layer.borderColor = .designSystem(.mainYellow)
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 12.5
        return label
    }()
    private lazy var doneButton: MainButton = {
        let button = MainButton(type: .home)
        button.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        self.courseTitleLabel.text = viewModel.courseTitle
    }
    
    init(type: AddCourseFlowType, viewModel: AddCourseCompleteViewModel) {
        self.type = type
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - UI
extension AddCourseCompleteViewController {
    private func setUI() {
        setAttributes()
        
        if type == .record {
            setRecordCompleteViewLayout()
        } else {
            setPlanCompleteViewLayout()
        }
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// RecordComplete 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setRecordCompleteViewLayout() {
        view.addSubviews(
            completeLabel,
            starLottie,
            constellationImageView,
            courseTitleLabel,
            doneButton
        )
        
        completeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        starLottie.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(105)
            make.height.equalTo(170)
        }
        
        constellationImageView.snp.makeConstraints { make in
            make.top.equalTo(starLottie.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(150)
        }
        
        courseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(constellationImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    /// PlanComplete 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setPlanCompleteViewLayout() {
        view.addSubviews(
            completeLabel,
            starLottie,
            constellationImageView,
            doneButton
        )
        
        completeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(180)
            make.centerX.equalToSuperview()
        }
        
        starLottie.snp.makeConstraints { make in
            make.top.equalTo(completeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(105)
            make.height.equalTo(170)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - User Interactions
extension AddCourseCompleteViewController {
    @objc
    private func didTapDoneButton(_ sender: UIButton) {
        viewModel.popToHomeView()
    }
}
