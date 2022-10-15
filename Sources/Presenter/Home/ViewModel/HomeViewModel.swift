//
//  HomeViewModel.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

final class HomeViewModel: BaseViewModel {
    var hasMate = true
    var constellations: [UIImage?] = [
        UIImage(named: "BusanCourseImage"),
        UIImage(named: "ChangwonCourseImage"),
        UIImage(named: "PohangCourseImage"),
        UIImage(named: "BusanCourseImage"),
        UIImage(named: "ChangwonCourseImage"),
        UIImage(named: "PohangCourseImage"),
        UIImage(named: "BusanCourseImage"),
        UIImage(named: "ChangwonCourseImage"),
        UIImage(named: "PohangCourseImage")
    ]
}
