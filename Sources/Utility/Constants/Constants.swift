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

    struct Image {
        static let chevron_left = "chevron_left"
        static let x_mark_circle_fill = "xmark.circle.fill"
        static let magnifyingglass = "magnifyingglass"
        static let deleteButton = "delete_button"
        static let navBarDeleteButton = "nav_bar_delete_button"
        static let photoIcon = "photo.on.rectangle.angled"
        static let closedLockIcon = "lock_closed"
        static let openLockIcon = "lock_open"
        static let appIcon = "app_icon"
        static let starAnnotation = "star_annotation"
        static let purplePlanet = "purple_planet"
    }
    
    struct Lottie {
        static let starLottie = "star_lottie"
    }

    struct Constraints {
        static let spaceBetweenkeyboardAndButton: CGFloat = -10
    }
}
