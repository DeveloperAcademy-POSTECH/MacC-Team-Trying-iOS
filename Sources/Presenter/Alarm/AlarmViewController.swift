//
//  AlarmViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

class AlarmViewController: UIViewController {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainLabel)
        view.backgroundColor = .designSystem(.mainYellow)
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }

}
