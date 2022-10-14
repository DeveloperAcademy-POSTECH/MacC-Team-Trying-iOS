//
//  FeedTestViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation

final class FeedTestViewModel: BaseViewModel {
}

struct TestViewModel {
    let id: Int
    let planet: String
    let title: String
    let body: String
    let date: String
    let tag: [String]
    let image: String
}
