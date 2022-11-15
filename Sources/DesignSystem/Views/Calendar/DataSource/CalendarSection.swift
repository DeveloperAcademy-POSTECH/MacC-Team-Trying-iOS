//
//  CalendarSection.swift
//  ComeItTests
//
//  Created by Jaeyong Lee on 2022/11/10.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum DayItem: Hashable {
    case day(DateCellModel)
}

enum CalendarSection: Hashable {
    typealias Item = DayItem
    case month([Item])
    case week([Item])
}
