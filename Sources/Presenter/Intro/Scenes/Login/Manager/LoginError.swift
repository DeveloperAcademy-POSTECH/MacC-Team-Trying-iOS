//
//  LoginError.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case parsing
    case appleLoginError
    case kakaoLoginError
    case noUser(String)
}
