//
//  AddCourseResponse.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

struct AddCourseResponse: Decodable {
    let courseId: Double
    var stars: [Star]
    
    struct Star: Decodable {
        let x: Double
        let y: Double
    }
}
    