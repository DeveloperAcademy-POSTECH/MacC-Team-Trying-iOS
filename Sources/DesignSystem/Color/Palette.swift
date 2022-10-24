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
    case gray252632
    case gray333333
    case gray3B3C46
    case gray818181
    case black
    case red
    case white
    case pinkEB97D9
    case orange
    case blue110B38

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
  	    case .gray252632:
            return "#252632FF"
        case .gray333333:
            return "#333333FF"
        case .gray3B3C46:
            return "#3B3C46FF"
        case .gray818181:
            return "#818181FF"
        case .black:
            return "#000000FF"
        case .red:
            return "#FF0000FF"
        case .white:
            return "#FFFFFFFF"
        case .pinkEB97D9:
            return "#EB97D9FF"
        case .orange:
            return "#EB911AFF"
        case .blue110B38:
            return "#110B38FF"
        }
    }
}
