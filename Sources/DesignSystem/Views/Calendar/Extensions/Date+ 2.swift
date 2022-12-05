//
//  Date+.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

extension Date {
    
    static let currentDateString = Date().dateToString()

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
    
    var firstDayOfTheMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    var monthBefore: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    var month2Before: Date {
        Calendar.current.date(byAdding: .month, value: -2, to: self)!
    }

    var monthAfter: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    var month2After: Date {
        Calendar.current.date(byAdding: .month, value: 2, to: self)!
    }

    var startDateOfWeek: Date {
        Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }

    func day(after: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: after, to: self)!
    }

    func day(before: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -before, to: self)!
    }

    func isDateInThisWeek() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
