//
//  AlarmReviewIdDTO.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct AlarmReviewIdDTO: Codable {
    let writerName, content: String
    let images: [String]
}
