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
    case grayEBEBF5
    case gray767680
    case black
    case red
    case white

    var hexString: String {
        switch self {
        case .mainYellow:
            return "#FFF56AFF"
        case .grayC5C5C5:
            return "#C5C5C5FF"
        case .grayEBEBF5:
            return "#EBEBF599"
        case .gray767680:
            return "#7676803D"
        case .black:
            return "#000000FF"
        case .red:
            return "#FF0000FF"
        case .white:
            return "#FFFFFFFF"
        }
    }
}
