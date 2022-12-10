//
//  FetchReviewDTO.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct FetchReviewDTO: Decodable {
    let myReview: Review?
    let mateReview: Review?
    
    struct Review: Codable {
        let reviewId: Int
        let writerName, content: String
        let images: [String]
    }
}
