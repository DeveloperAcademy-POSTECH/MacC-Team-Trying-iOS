//
//  CalendarDiffableDataSource.swift
//  ComeItTests
//
//  Created by Jaeyong Lee on 2022/11/10.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class PresentCalendarDiffableDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarSection.Item> {
   
    var selecteDate: YearMonthDayDate?
    
    init(collectionView: UICollectionView) {
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .day(let model):
                let cell = collectionView.dequeueReusableCell(DateCollectionViewCell.self, for: indexPath)
                cell.configure(with: model)

                // 현재 날짜가 오늘이라면
                // 1. 노란색 처리
                // 2. 눌림 처리
                if model.date == YearMonthDayDate.today {
                    cell.isToday()
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                }

                return cell
            }
        }
    }
}
