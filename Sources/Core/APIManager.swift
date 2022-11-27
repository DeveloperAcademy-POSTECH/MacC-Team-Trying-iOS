//
//  APIManager.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class APIManager {
#if DEBUG
    static let baseURL = "https://comeit.site"
#else
    static let baseURL = "https://wouldulike.site"
#endif
}
