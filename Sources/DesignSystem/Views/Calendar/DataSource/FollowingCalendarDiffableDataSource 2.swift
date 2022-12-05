//
//  FollowingCalendarDiffableDataSource.swift
//  ComeItTests
//
//  Created by Jaeyong Lee on 2022/11/10.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class FollowingCalendarDiffableDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarSection.Item> {

    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .day(let model):
                let cell = collectionView.dequeueReusableCell(DateCollectionViewCell.self, for: indexPath)
                cell.configure(with: model)
                return cell
            }
        }
    }
}
