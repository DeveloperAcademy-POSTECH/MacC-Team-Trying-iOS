//
//  SelectPlanetCollectionView.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class SelectPlanetCollectionView: UICollectionView {
    static let cellIdentifier = "PlanetCollectionViewCell"

    static let spacing: CGFloat = 18
    static let sideInset: CGFloat = 93

    convenience init() {
        let layout = HorizontalCarouselLayout()

        let width: CGFloat = (UIScreen.main.bounds.width - Self.sideInset * 2)
        let height: CGFloat = width * 144 / 203
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Self.spacing
        layout.minimumLineSpacing = Self.spacing

        self.init(frame: .zero, collectionViewLayout: layout)
        self.contentInset = .init(top: 0, left: Self.sideInset, bottom: 0, right: Self.sideInset)
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = true
        self.decelerationRate = .fast
        self.isPagingEnabled = false
        register(PlanetCollectionViewCell.self)
    }
}
