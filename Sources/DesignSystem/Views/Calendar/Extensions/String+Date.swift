//
//  String+.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

extension String {
    var date: Date? {
        Formatter.calendarDateFormatter.date(from: self)
    }
}
