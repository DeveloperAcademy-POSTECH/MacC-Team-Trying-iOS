//
//  DeleteReviewRepository.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol DeleteReviewRepository {
    func deleteReview(_ reviewId: Int) async throws
}
