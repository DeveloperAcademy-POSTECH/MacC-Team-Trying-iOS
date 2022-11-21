//
//  UserRequestModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum UserRequestModel {
    struct EditNickname: RequestBody {
        let name: String
    }
    struct EditPlanet: RequestBody {
        let name: String
        let date: String
        let image: String
    }

    struct EditPassword: RequestBody {
        let previousPassword: String
        let updatePassword: String
    }
}
