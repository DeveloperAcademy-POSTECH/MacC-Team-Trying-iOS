//
//  AlarmNViewConroller.swift
//  MatStar
//
//  Created by uiskim on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

class AlarmNViewConroller: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor = .designSystem(.gray818181)
        tv.register(AlarmTableViewcell.self, forCellReuseIdentifier: AlarmTableViewcell.cellID)
        tv.tableHeaderView = UIView()
        return tv
    }()

//    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.tabBar.isHidden = true
//        super.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        tabBarController?.tabBar.isHidden = false
//        super.viewWillDisappear(animated)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setConfiguration()
    }

    private func setLayout() {
        tableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.top.equalToSuperview()
        }
    }

    private func setConfiguration() {
        tableView.dataSource = self
    }
    private func setAttribute() {
        view.addSubview(tableView)
    }
}

extension AlarmNViewConroller: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewcell.cellID, for: indexPath) as? AlarmTableViewcell else { return UITableViewCell() }
        cell.info = .init(iconImageString: "MyPlanetImage", title: "아령아령아령하세요", description: "아령아령아령하세요아령아령\n아령하세요아령아령아령하세요", time: "217시간전")
        return cell
    }

}
