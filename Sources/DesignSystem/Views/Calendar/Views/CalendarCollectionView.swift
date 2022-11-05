//
//  CalendarCollectionView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class CalendarCollectionView: UICollectionView {

    convenience init() {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 18
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        let width: CGFloat = (DeviceInfo.screenWidth - 80 - inset * 6 - 1) / 7
        layout.itemSize = CGSize(width: width, height: width)
        self.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.allowsMultipleSelection = false
        self.register(DateCell.self)
    }
}
