//
//  TestViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {

    lazy var calendarView = CalendarView(today: .init(), frame: .init(origin: .zero, size: .init(width: DeviceInfo.screenWidth - 40, height: 0)))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(calendarView)

        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
