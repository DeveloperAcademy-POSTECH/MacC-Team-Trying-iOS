//
//  Palette.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

enum Palette: String {
    case mainYellow
    case grayC5C5C5

    var hexString: String {
        switch self {
        case .mainYellow:
            return "#FFF56AFF"
            
        case .grayC5C5C5:
            return "#C5C5C5FF"
        }
    }
}
