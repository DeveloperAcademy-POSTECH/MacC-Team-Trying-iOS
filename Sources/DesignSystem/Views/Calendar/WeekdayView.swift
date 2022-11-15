//
//  WeekdayView.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/05.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class WeekdayView: UIView {
    let weekdayArray: [String] = ["일", "월", "화", "수", "목", "금", "토"]

    lazy var weekdayCollectionView = WeekdayCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupWeekDayCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupWeekDayCollectionView() {
        weekdayCollectionView.dataSource = self
        addSubview(weekdayCollectionView)
        weekdayCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
    }
}

extension WeekdayView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(WeekdayCell.self, for: indexPath)
        cell.configure(with: weekdayArray[indexPath.row])
        return cell
    }

}
