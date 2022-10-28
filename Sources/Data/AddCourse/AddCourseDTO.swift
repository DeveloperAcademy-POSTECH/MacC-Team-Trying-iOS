//
//  AddCourseDTO.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

struct AddCourseDTO: Encodable {
    let planetId: String
    let title: String
    let body: String
    let access: String
    var tags: [Tag]
    
    struct Tag: Encodable {
        let place: Place
        let name: String
    }
    
    struct Place: Encodable {
        let name: String
        let latitude: Double
        let longitude: Double
    }
}
