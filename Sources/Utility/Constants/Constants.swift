//
//  Constants.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

struct Constants {
    // Coordinator에서 사용하는 문자열 상수들입니다.
    struct Coordinator {
        static let home = "Home"
        static let search = "Search"
        static let feed = "Feed"
        static let profile = "Profile"
        
        static let homeIcon = "ic_home"
        static let searchIcon = "ic_search"
        static let feedIcon = "ic_feed"
        static let profileIcon = "ic_profile"
    }
    
    struct Screen {
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
    
    struct Image {
        static let chevron_left = "chevron_left"
        static let x_mark = "x_mark"
    }
}
