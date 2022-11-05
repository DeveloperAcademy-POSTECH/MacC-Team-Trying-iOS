//
//  Date+.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

extension Date {

    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var firstDayOfTheMonth: Date? {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))
    }

    var monthBefore: Date? {
        Calendar.current.date(byAdding: .month, value: -1, to: self)
    }

    var monthAfter: Date? {
        Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func getDate(year: Int, month: Int, day: Int) -> Date? {
        var datecomponents = DateComponents()
        datecomponents.year = year
        datecomponents.month = month
        datecomponents.day = day
        datecomponents.timeZone = .autoupdatingCurrent

        return Calendar.current.date(from: datecomponents)
    }
}
