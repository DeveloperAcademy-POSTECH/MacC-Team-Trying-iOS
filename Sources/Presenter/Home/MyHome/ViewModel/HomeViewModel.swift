//
//  HomeViewModel.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

protocol AlarmViewCoordinating {
    func pushToAlarmViewController()
}

protocol CourseDetailCoordinating {
    func pushToCourseDetailViewController()
}

// TODO : - 코스등록ViewController로 연결
protocol CourseRegistering {
    func pushToCourseRegisterViewController()
}

struct Constellation {
    let name: String
    let data: String
    let image: UIImage?
}

final class HomeViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    var numberOfColum: Int {
        switch constellations.count {
        case 0...1:
            return 1
        case 2...4:
            return 2
        default:
            return 3
        }
    }

    var hasMate = true
    
    var constellations: [Constellation] = [
        Constellation(name: "창원 야구장", data: "2022-10-01(토)", image: UIImage(named: "Changwon")),
        Constellation(name: "광안대교 야경", data: "2022-10-02(일)", image: UIImage(named: "Busan")),
        Constellation(name: "포항공대", data: "2022-10-03(월)", image: UIImage(named: "Pohang")),
        Constellation(name: "부산", data: "2022-10-04(화)", image: UIImage(named: "Busan")),
        Constellation(name: "애플아카데미", data: "2022-10-05(수)", image: UIImage(named: "Pohang")),
        Constellation(name: "포항", data: "2022-10-06(목)", image: UIImage(named: "Pohang")),
        Constellation(name: "부산대학교", data: "2022-10-07(금)", image: UIImage(named: "Busan")),
        Constellation(name: "인천ssg파크", data: "2022-10-08(토)", image: UIImage(named: "Pohang"))
    ]
    
    func pushToAlarmView() {
        guard let coordinator = coordinator as? AlarmViewCoordinating else { return }
        coordinator.pushToAlarmViewController()
    }
    
    func pushToCourseDetailView() {
        guard let coordinator = coordinator as? CourseDetailCoordinating else { return }
        coordinator.pushToCourseDetailViewController()
    }

}
