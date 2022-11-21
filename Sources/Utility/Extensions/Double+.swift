//
//  Double+.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension Double {
    func changeDistance() -> String {
        if self < 1 {
            return "\(Int(self * 1000))m"
        } else {
            let str = String(format: "%.1f", self)
            return "\(str)km"
        }
    }
}
