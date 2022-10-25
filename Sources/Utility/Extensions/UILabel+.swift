//
//  UILabel+.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UILabel {

    /// UILabel의 texg의 현재 줄 개수를 리턴합니다.
    /// - Returns: 라벨에 보여지는 현재 줄의 수
    func countCurrentLines() -> Int {
        
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font else { return 0 }

        var attributes = [NSAttributedString.Key: Any]()

        // kern을 설정하면 자간 간격이 조정되기 때문에, 크기에 영향을 미칠 수 있음.
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            let result = (key == .kern)
            return result
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font

        // width을 제한한 상태에서 해당 Text의 Height를 구하기 위해 boundingRect 사용
        let labelTextSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )

        // 총 Height에서 한 줄의 Line Height를 나누면 현재 총 Line 수
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
}
