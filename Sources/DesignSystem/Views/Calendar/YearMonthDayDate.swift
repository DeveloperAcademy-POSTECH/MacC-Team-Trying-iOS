//
//  YearMonthDayDate.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/06.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct YearMonthDayDate: Hashable {
    let year: Int
    let month: Int
    let day: Int
}

extension YearMonthDayDate {
    func compareDate(with date: YearMonthDayDate) -> Bool {
        date.year == self.year && date.month == self.month && date.day == self.day
    }

    func asDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = self.day
        dateComponents.month = self.month
        dateComponents.year = self.year
        return Calendar.autoupdatingCurrent.date(from: dateComponents)!
    }

    static var today: YearMonthDayDate {
        let date = Date()
        return .init(year: date.year, month: date.month, day: date.day)
    }
}
