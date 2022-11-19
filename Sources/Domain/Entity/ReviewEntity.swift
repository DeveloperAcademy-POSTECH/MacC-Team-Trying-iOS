//
//  ReviewEntity.swift
//  ComeItTests
//
//  Created by 김승창 on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct ReviewEntity {
    let id: Int
    var imagesURL: [String]
    let author: UserEntity
    let content: String
}
