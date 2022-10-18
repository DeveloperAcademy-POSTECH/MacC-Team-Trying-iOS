//
//  CourseImageCollectionView.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

class CourseImageCollectionView: UICollectionView {
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 113, height: 169)
        flowLayout.minimumLineSpacing = 5
        self.init(frame: .zero, collectionViewLayout: flowLayout)
    }
}
