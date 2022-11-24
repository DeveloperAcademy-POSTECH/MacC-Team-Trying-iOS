//
//  AlarmViewController.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

class AlarmViewController: BaseViewController {

    let alarmViewModel: AlarmViewModel
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshAlarmData), for: .valueChanged)
        return rc
    }()
    
    init(alarmViewModel: AlarmViewModel) {
        self.alarmViewModel = alarmViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func refreshAlarmData(_ sender: Any) {
        alarmViewModel.fetchAlamrs()
    }
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor = .designSystem(.gray818181)
        tv.register(AlarmTableViewcell.self, forCellReuseIdentifier: AlarmTableViewcell.cellID)
        tv.backgroundColor = .clear
        tv.tableHeaderView = UIView()
        tv.addSubview(refreshControl)
        return tv
    }()

    private let noAlarmStackView: UIStackView = {
        let noAlarmLabel = UILabel()
        noAlarmLabel.font = .designSystem(weight: .regular, size: ._13)
        noAlarmLabel.text = "현재 알림 내역이 없습니다."
        noAlarmLabel.textColor = .designSystem(.grayC5C5C5)
        
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        imageView.image = UIImage(named: "noAlarmPlanet")
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [noAlarmLabel, imageView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        alarmViewModel.fetchAlamrs()
        setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc
    func backTap() {
        alarmViewModel.popToBackViewController()
    }
    
    func setAuthAlertAction() {
        let authAlertController = UIAlertController(title: "알림", message: "알림을 전체 삭제 하시겠어요?", preferredStyle: .alert)

        let getAuthAction = UIAlertAction(
            title: "삭제할래요",
            style: .destructive,
            handler: { _ in
                self.alarmViewModel.allDeleteTap()
            }
        )
        let cancelAction = UIAlertAction(
            title: "아니요",
            style: .cancel
        )
        authAlertController.addAction(getAuthAction)
        authAlertController.addAction(cancelAction)
        self.present(authAlertController, animated: true, completion: nil)
    }
    
    @objc
    func allDeleteTap() {
        DispatchQueue.main.async {
            self.setAuthAlertAction()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setConfiguration()
        bind()
    }

    private func setLayout() {
        
        noAlarmStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func bind() {
        
        alarmViewModel.$alarms
            .receive(on: DispatchQueue.main)
            .sink { alamrs in
                self.noAlarmStackView.isHidden = alamrs.isEmpty ? false : true
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            .cancel(with: cancelBag)
    }
    
    private func setConfiguration() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setAttribute() {
        view.addSubview(noAlarmStackView)
        view.addSubview(tableView)
    }
    
}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alarmViewModel.alarmTap(index: indexPath.row)
    }
}

extension AlarmViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmViewModel.countOfAlarms
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewcell.cellID, for: indexPath) as? AlarmTableViewcell else { return UITableViewCell() }
        cell.info = alarmViewModel.makeAlarmRowWithInfo(index: indexPath.row)
        return cell
    }

}

extension AlarmViewController {
    private func setNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.gmarksans(weight: .bold, size: ._15)]
        
        let configure = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .default)
        
        title = "알림"
        
        let chevronImage = UIImage(systemName: "chevron.left", withConfiguration: configure)
        
        let trashImage = UIImage(systemName: "trash", withConfiguration: configure)

        let resizedChevronImage = chevronImage?.resizeImageTo(size: .init(width: 20, height: 30))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: resizedChevronImage,
            style: .plain,
            target: self,
            action: #selector(backTap)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .white

        let resizedTrashImage = trashImage?.resizeImageTo(size: .init(width: 25, height: 25))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: resizedTrashImage,
            style: .plain,
            target: self,
            action: #selector(allDeleteTap)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

extension AlarmViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               alarmViewModel.deleteAlarmAt(indexPath.row)
           }
       }
}
