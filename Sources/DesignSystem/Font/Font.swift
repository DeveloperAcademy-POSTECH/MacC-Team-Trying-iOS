//
//  Font.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

enum Font {
    enum Name: String {
        case system
    }
    
    enum Size: CGFloat {
		case _11 = 11
        case _13 = 13
        case _15 = 15
        case _20 = 20
    }

    enum Weight: String {
        case heavy = "Heavy"
        case bold = "Bold"
        case regular = "Regular"
        case light = "Light"

        var real: UIFont.Weight {
            switch self {
            case .heavy:
                return .heavy
                
            case .bold:
                return .bold
                
            case .regular:
                return .regular
                
            case .light:
                return .light
            }
        }
    }

    struct CustomFont {
        private let _name: Name
        private let _weight: Weight

        init(name: Name, weight: Weight) {
            self._name = name
            self._weight = weight
        }

        var name: String {
            "\(_name.rawValue)TTF\(_weight.rawValue)"
        }

        var `extension`: String {
            "ttf"
        }
    }

    /// 모든 폰트 파일을 등록합니다.
    /// 앱 실행 시 최초 한번만 호출합니다.
    static func registerFonts() {
        fonts.forEach { font in
            Font.registerFont(fontName: font.name, fontExtension: font.extension)
        }
    }
}

extension Font {
    static var fonts: [CustomFont] {
        [
            // TODO: 사용할 폰트를 아래 형태와 같이 추가할 예정입니다.
            // CustomFont(name: <#T##Name#>, weight: <#T##Weight#>)
        ]
    }

    private static func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle(identifier: "com.Try-ing.MatStar")?.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
