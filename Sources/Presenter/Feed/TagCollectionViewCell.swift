//
//  CourseTagCollectionViewCell.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//
//
import SnapKit
import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    static let identifier = "TagCollectionViewCell"

    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = TagCollectionViewCell()
        cell.configure(name: name)

        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }

    private let titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    private func setupView() {
        backgroundColor = .clear
        layer.borderColor = UIColor.designSystem(.pinkEB97D9)?.cgColor
        layer.borderWidth = 2.0
        titleLabel.font = UIFont.designSystem(weight: .bold, size: ._10)
        titleLabel.textColor = UIColor.designSystem(.pinkEB97D9)
        titleLabel.textAlignment = .center

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
    }

    func configure(name: String?) {
        titleLabel.text = name
    }
}
