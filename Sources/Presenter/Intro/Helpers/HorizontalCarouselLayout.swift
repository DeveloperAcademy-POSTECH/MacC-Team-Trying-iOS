//
//  HorizontalCarouselLayout.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class HorizontalCarouselLayout: UICollectionViewFlowLayout {

    private var isInit: Bool = false

    override func prepare() {
        super.prepare()
        guard !isInit else { return }
        self.isInit = true
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superAttributes = super.layoutAttributesForElements(in: rect)

        superAttributes?.forEach { attributes in
            guard let collectionView = self.collectionView else { return }

            let collectionViewCenter = collectionView.frame.size.width / 2
            let offsetX = collectionView.contentOffset.x
            let center = attributes.center.x - offsetX

            let maxDis = self.itemSize.width + self.minimumLineSpacing
            let dis = min(abs(collectionViewCenter - center), maxDis)

            let ratio = (maxDis - dis) / maxDis
            let scale = ratio * (1 - 0.65) + 0.7

            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return superAttributes
    }
}
