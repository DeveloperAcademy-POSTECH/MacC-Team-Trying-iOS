//
//  Formatter.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct Formatter {
    static let calendarDateFormatter: DateFormatter = {
        let v = DateFormatter()
        v.dateFormat = "yyyy MM월"
        return v
    }()

    static let dateFormatter: DateFormatter = {
        let v = DateFormatter()
        v.dateFormat = "yyyy-MM-dd"
        return v
    }()
}
