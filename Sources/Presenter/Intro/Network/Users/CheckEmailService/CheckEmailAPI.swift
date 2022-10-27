//
//  CheckEmailAPI.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum CheckEmailAPI {
    case validationEmail(CheckEmailRequestModel)
}

extension CheckEmailAPI: TargetType {
   
    var method: HTTPMethod { .get }

    var query: QueryItems? {
        switch self {
        case .validationEmail(let checkEmailRequestModel):
            return ["email": checkEmailRequestModel.email]
        }
    }

    var path: String { "/users/exist" }
}
