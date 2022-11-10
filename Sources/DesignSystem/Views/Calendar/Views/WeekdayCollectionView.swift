//
//  WeekdayCollectionView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class WeekdayCollectionView: UICollectionView {

    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = CalendarView.inset
        layout.minimumInteritemSpacing = CalendarView.inset
        let width: CGFloat = (DeviceInfo.screenWidth - 80 - CalendarView.inset * 6 - 20) / 7
        let height: CGFloat = 12
        layout.itemSize = .init(width: width, height: height)
        self.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsSelection = false
        self.isScrollEnabled = false
        self.register(WeekdayCell.self)
    }
}
