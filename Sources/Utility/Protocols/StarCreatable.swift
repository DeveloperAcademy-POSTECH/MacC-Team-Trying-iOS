//
//  StarCreatable.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol StarCreatable {
    func makeStars(places: [Place]) -> UIImage?
}
