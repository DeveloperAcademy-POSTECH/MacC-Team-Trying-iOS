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
        let inset: CGFloat = 18
        layout.sectionInset = .zero
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        let width: CGFloat = (DeviceInfo.screenWidth - 80 - inset * 6 - 1) / 7
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
