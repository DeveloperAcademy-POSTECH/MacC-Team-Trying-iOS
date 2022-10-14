//
//  FeedViewControllerCell.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FeedCollectionViewCell: UICollectionViewCell {

    static let identifier = "FeedCollectionViewCell"
    // Subviews
    private let planetNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private let planetLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    private let planetLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with: TestViewModel) {


    }
}
