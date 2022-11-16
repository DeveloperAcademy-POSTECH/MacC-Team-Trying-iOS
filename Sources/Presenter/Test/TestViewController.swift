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

    let blueView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(calendarView)
        calendarView.delegate = self
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        let button = UIButton(type: .system)

        button.addTarget(self, action: #selector(animated), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
            make.leading.trailing.equalToSuperview()
        }
        button.setTitle("fdsafasdfdsa", for: .normal)

        blueView.backgroundColor = .blue

        view.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(100)
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }

    @objc
    func animated() {
        blueView.snp.updateConstraints { make in
            make.height.equalTo(200)
        }
        UIView.animate(withDuration: 2.0, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }

}

extension TestViewController: CalendarViewDelegate {
    func switchCalendarButtonDidTapped() {
        //
    }
    
    func selectDate(_ date: Date?) {
        //
    }
    
    func scrollViewDidEndDecelerating() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
}
