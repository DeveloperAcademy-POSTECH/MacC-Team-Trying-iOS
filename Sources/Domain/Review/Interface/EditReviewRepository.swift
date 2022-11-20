//
//  EditReviewRepository.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

protocol EditReviewRepository {
    func editReview(reviewId: Int, content: String, images: [UIImage]) async throws
}
