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
        static let log = "Log"
        static let profile = "Profile"
        
        static let homeIcon = "ic_home"
        static let logIcon = "ic_log"
        static let profileIcon = "ic_profile"
    }

    struct Image {
        static let navBackButton = "nav_chevron_left"
        static let chevron_left = "chevron.left"
        static let chevron_right = "chevron.right"
        static let x_mark_circle_fill = "xmark.circle.fill"
        static let magnifyingglass = "magnifyingglass"
        static let deleteButton = "delete_button"
        static let navBarDeleteButton = "nav_bar_delete_button"
        static let navBarPopButton = "nav_bar_pop_button"
        static let photoIcon = "photo.on.rectangle.angled"
        static let closedLockIcon = "lock_closed"
        static let openLockIcon = "lock_open"
        static let appIcon = "app_icon"
        static let starAnnotation = "star_annotation"
        static let purplePlanet = "purple_planet"
        static let ticketIcon = "ticket_icon"
        static let pencil = "pencil"
        static let map = "map"
        static let setting = "gearshape.fill"
        static let emptyResultStar = "empty_result_star"
        static let placeResultAnnotation = "PlaceResultAnnotation"
        static let editDateImage = "EditDateImage"
    }
    
    struct Lottie {
        static let starLottie = "star_lottie"   // 코스 등록 마무리에 사용되는 노란색 큰 별
        static let mainStar = "main_star"       // 별자리에 사용되는 반짝이는 하얀색 작은 별
        static let middleStar = "middle_star"   // 중간 크기의 배경화면 별
    }

    struct Constraints {
        static let spaceBetweenkeyboardAndButton: CGFloat = -10
    }
}
