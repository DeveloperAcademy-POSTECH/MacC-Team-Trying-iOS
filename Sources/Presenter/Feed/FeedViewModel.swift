//
//  FeedViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Modified by 정영진 on 2022/10/21
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation

final class FeedViewModel: BaseViewModel {

    static let shared = FeedViewModel()

    override private init() {}

    private let data = [Course]()

    func fetchData() {

    }

    func didTapMapButton() { }

    func didTapListButton() { }

    func didTapLikeButton() { }

    func didTapFollowButton() { }
}

// MARK: MOCK
struct TestViewModel {
    let id: Int
    let planet: String
    let planetImage: String
    let title: String
    let body: String
    let date: String
    let tag: [String]
    let images: [String]
}
