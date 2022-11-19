//
//  PushSettingViewController.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit
import UserNotifications
import Firebase

class PushSettingViewController: BaseViewController, UNUserNotificationCenterDelegate {
    
    let viewModel: PushNotificationViewModel
    
    private let alarmMentStackView: UIStackView = {
        let alarmLabel = UILabel()
        alarmLabel.font = .designSystem(weight: .regular, size: ._15)
        alarmLabel.text = "활동 알림"
        alarmLabel.textColor = .designSystem(.white)
        let alarmDescriptionLabel = UILabel()
        alarmDescriptionLabel.font = .designSystem(weight: .regular, size: ._13)
        alarmDescriptionLabel.textColor = .designSystem(.grayC5C5C5)
        alarmDescriptionLabel.text = "후기작성, 코스생성, D-day"
        
        let stackView = UIStackView(arrangedSubviews: [alarmLabel, alarmDescriptionLabel])
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var notificationSwitch: UISwitch = {
       let controlSwicth: UISwitch = UISwitch()
        controlSwicth.addTarget(self, action: #selector(onClickSwitch), for: UIControl.Event.valueChanged)
//        controlSwicth.isOn = viewModel.permission
       return controlSwicth
    }()
    
    init(viewModel: PushNotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var observer: NSObjectProtocol?
    
    private func bind() {
        viewModel.$permission
            .sink { permission in
                DispatchQueue.main.async {
                    self.notificationSwitch.isOn = permission
                }
            }
            .cancel(with: cancelBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setConfiguration()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                print("!!!!",self, self?.viewModel.permission, "->")
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        if settings.authorizationStatus == .authorized {
                            //그냥 나갓다와도 바뀌는문제.
                            self?.viewModel.permission = true
                        } else {
                            self?.viewModel.permission = false
                        }
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
        }
        setNavigation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setAttribute() {
        view.addSubview(alarmMentStackView)
        view.addSubview(notificationSwitch)
    }
    
    private func setLayout() {
        alarmMentStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        notificationSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(alarmMentStackView.snp.centerY)
            make.width.equalTo(51)
            make.height.equalTo(31)
        }
    }
    private func setConfiguration() {
        
    }
    
    private func setNavigation() {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 15)!]
        title = "푸쉬 설정"
        guard let chevronImage = UIImage(named: "chevron_left") else { return }
        let resizedChevronImage = chevronImage.resizeImageTo(size: .init(width: 16, height: 26))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: resizedChevronImage,
            style: .plain,
            target: self,
            action: #selector(backTap)
        )
    }
    
    func setAuthAlertAction() {
            let authAlertController : UIAlertController

            authAlertController = UIAlertController(title: "위치 사용 권한이 필요합니다.", message: "위치 권한을 허용해야만 앱을 사용하실 수 있습니다.", preferredStyle: .alert)

            let getAuthAction = UIAlertAction(title: "설정", style: .default, handler: { (UIAlertAction) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings,options: [:], completionHandler: nil)
                }
            })
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: { _ in
            self.notificationSwitch.isOn = false
        })
            authAlertController.addAction(getAuthAction)
            authAlertController.addAction(cancelAction)
            self.present(authAlertController, animated: true, completion: nil)
        }
    
    func requestPermission() {
        
        if !viewModel.permission {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .denied {
                    DispatchQueue.main.async {
                        self.setAuthAlertAction()
                    }
                } else {
                    self.viewModel.permission = true
                }
            }
            
        } else {
            viewModel.permission.toggle()
            print("!!1")
        }
    }
    
    @objc
    func onClickSwitch(sender: UISwitch) {
        requestPermission()
    }
    
    @objc
    func backTap() {
        viewModel.pop()
    }
}

protocol EditNotificationCoordinating {
    func pushToEditNotificationView()
}

extension ProfileViewModel {
    func pushToEditNotificationView() {
        guard let coordinator = coordinator as? EditNotificationCoordinating else { return }
        coordinator.pushToEditNotificationView()
    }
}

extension ProfileCoordinator: EditNotificationCoordinating {
    func pushToEditNotificationView() {
        let viewModel = PushNotificationViewModel(coordinator: self)
        let viewController = PushSettingViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
