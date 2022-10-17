//
//  UIImage+.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(_ name: AssetName) {
        self.init(named: name.rawValue)
    }
}
