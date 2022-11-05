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

    let calendarView = CalendarView(today: .init())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(calendarView)

        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(CalendarView.height)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.calendarCollectionView.collectionViewLayout.invalidateLayout()
    }
}
