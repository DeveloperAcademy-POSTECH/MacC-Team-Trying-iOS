//
//  FollowingMonthCollectionView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class FollowingMonthCollectionView: UICollectionView {

    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = CalendarView.inset
        layout.minimumInteritemSpacing = CalendarView.inset
        let width: CGFloat = (DeviceInfo.screenWidth - 80 - CalendarView.inset * 6 - 1) / 7
        layout.itemSize = CGSize(width: width, height: width)
        self.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.allowsMultipleSelection = false
        self.register(DateCollectionViewCell.self)
    }
}
