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
    
    init(alarmViewModel: AlarmViewModel) {
        self.alarmViewModel = alarmViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor = .designSystem(.gray818181)
        tv.register(AlarmTableViewcell.self, forCellReuseIdentifier: AlarmTableViewcell.cellID)
        tv.tableHeaderView = UIView()
        return tv
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
    
    @objc
    func allDeleteTap() {
        alarmViewModel.allDeleteTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setConfiguration()
        bind()
    }

    private func setLayout() {
        tableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.top.equalToSuperview()
        }
    }

    private func bind() {
        alarmViewModel.$alarms
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .cancel(with: cancelBag)
    }
    
    private func setConfiguration() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setAttribute() {
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 15)!]
        title = "알림"

        guard let chevronImage = UIImage(named: "chevron_left"),
              let trashImage = UIImage(named: "deletetong") else { return }

        let resizedChevronImage = chevronImage.resizeImageTo(size: .init(width: 16, height: 26))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: resizedChevronImage,
            style: .plain,
            target: self,
            action: #selector(backTap)
        )

        let resizedTrashImage = trashImage.resizeImageTo(size: .init(width: 21, height: 21))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: resizedTrashImage,
            style: .plain,
            target: self,
            action: #selector(allDeleteTap)
        )
    }
}
