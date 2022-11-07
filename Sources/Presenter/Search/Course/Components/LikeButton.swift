//
//  LikeButton.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class LikeButton: UIButton {

    convenience init() {
        self.init(frame: .zero)
        setUI()
    }
    
    private func setUI() {
        self.snp.makeConstraints { make in
            make.width.equalTo(19)
            make.height.equalTo(18)
        }
    }
    
    func toggleLike(isLike: Bool) {
        print(isLike)
        setImage(UIImage(named: isLike ? "like_image" : "unlike_image"), for: .normal)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        let touchArea = bounds.insetBy(dx: -30, dy: -30)
        return touchArea.contains(point)
    }

}
