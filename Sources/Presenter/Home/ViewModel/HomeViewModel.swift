//
//  HomeViewModel.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

struct Constellation {
    let name: String
    let image: UIImage?
}

final class HomeViewModel: BaseViewModel {
    
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
        Constellation(name: "창원 야구장", image: UIImage(named: "Changwon")),
        Constellation(name: "광안대교 야경", image: UIImage(named: "Busan")),
        Constellation(name: "포항공대", image: UIImage(named: "Pohang")),
        Constellation(name: "부산", image: UIImage(named: "Busan")),
        Constellation(name: "애플아카데미", image: UIImage(named: "Pohang")),
        Constellation(name: "포항", image: UIImage(named: "Pohang")),
        Constellation(name: "부산대학교", image: UIImage(named: "Busan")),
        Constellation(name: "인천ssg파크", image: UIImage(named: "Pohang"))
    ]
}
