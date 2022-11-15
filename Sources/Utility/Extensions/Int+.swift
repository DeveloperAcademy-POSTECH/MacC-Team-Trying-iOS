//
//  Int+.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

extension Int {
    func changeDistance() -> String {
        switch self {
        case let self where self > 1000 :
            return "\(self / 1000)km"
        default:
            return "\(self)m"
        }
    }
}
