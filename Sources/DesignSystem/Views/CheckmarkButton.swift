//
//  CheckMarkButton.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class CheckMarkButton: BaseButton {

    var isChecked: Bool = false {
        didSet {
            let image: UIImage? = isChecked ? .init(.btn_check) : .init(.btn_uncheck)
            setImage(image, for: .normal)
        }
    }

    override func setAttribute() {
        super.setAttribute()

        self.imageView?.contentMode = .scaleAspectFit
        setImage(.init(.btn_uncheck), for: .selected)
    }
}
