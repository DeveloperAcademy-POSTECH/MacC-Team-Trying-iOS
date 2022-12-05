//
//  FetchReviewRepository.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol FetchReviewRepository {
    func fetchReviewAsync(courseId: Int) async throws -> [ReviewEntity]    
}
