//
//  LogTicketLabel.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class LogTicketLabel: UILabel {
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        self.text = title
        self.font = UIFont.designSystem(weight: .medium, size: ._13)
        self.textColor = color
        self.textAlignment = .left
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        self.font = UIFont.designSystem(weight: .medium, size: ._13)
        self.textColor = color
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
