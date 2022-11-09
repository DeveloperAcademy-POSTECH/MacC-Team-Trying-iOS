//
//  TermLabel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class TermLabel: BaseLabel {

    override func setAttribute() {
        super.setAttribute()
        self.font = .designSystem(weight: .regular, size: ._13)
    }
}
