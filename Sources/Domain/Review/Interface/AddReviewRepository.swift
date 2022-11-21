//
//  AddReviewRepository.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

protocol AddReviewRepository {
    func addReview(courseId: Int, content: String, images: [UIImage]) async throws -> Int
}
