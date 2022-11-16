//
//  AlarmNViewConroller.swift
//  MatStar
//
//  Created by uiskim on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

class AlarmViewConroller: BaseViewController {

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
        alarmViewModel.fetchAlamrs()
        setNavigation()
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

extension AlarmViewConroller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alarmViewModel.alarmTap(index: indexPath.row)
    }
}

extension AlarmViewConroller: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alarmViewModel.countOfAlarms
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewcell.cellID, for: indexPath) as? AlarmTableViewcell else { return UITableViewCell() }
        cell.info = alarmViewModel.makeAlarmRowWithInfo(index: indexPath.row)
        return cell
    }

}

extension AlarmViewConroller {
    private func setNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 15)!]
        title = "알림"

        guard let chevronImage = UIImage(named: "chevron_left"),
              let trashImage = UIImage(named: "deletetong") else { return }

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronImage,
            style: .plain,
            target: self,
            action: #selector(backTap)
        )

        let resizedTrashImage = trashImage.resizeImage(size: CGSize(width: 18, height: 18)).withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: resizedTrashImage,
            style: .plain,
            target: self,
            action: #selector(allDeleteTap)
        )
    }
}
extension UIImage {
  func resizeImage(size: CGSize) -> UIImage {
    let originalSize = self.size
    let ratio: CGFloat = {
        originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                          1 / (size.height / originalSize.height)
    }()
      return UIImage(
        cgImage: self.cgImage!,
        scale: self.scale * ratio,
        orientation: self.imageOrientation
      )
  }
}
