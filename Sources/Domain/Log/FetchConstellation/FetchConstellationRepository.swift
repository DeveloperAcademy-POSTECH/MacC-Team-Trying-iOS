//
//  ConstellationRepository.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol FetchConstellationRepository {
    func fetchLogAsyc() async throws -> [TestCourse]
}
