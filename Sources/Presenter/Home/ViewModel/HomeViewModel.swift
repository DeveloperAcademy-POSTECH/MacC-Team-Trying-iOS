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

    var hasMate = true
    var constellations: [Constellation] = [
        Constellation(name: "창원 야구장", image: UIImage(named: "Changwon")),
        Constellation(name: "광안리 야경보러 간날", image: UIImage(named: "Busan")),
        Constellation(name: "포항공대", image: UIImage(named: "Pohang")),
        Constellation(name: "부산", image: UIImage(named: "Busan")),
        Constellation(name: "포항공대애플아카데미 기숙사", image: UIImage(named: "Pohang"))
    ]
}
