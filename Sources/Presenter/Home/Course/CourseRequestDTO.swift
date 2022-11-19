//
//  CourseRequestDTO.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class CourseRequestDTO {
    var id: Int?
    @Published var title: String
    var date: String
    var places: [Place]
    
    init(id: Int? = nil, title: String, date: String, places: [Place]) {
        self.id = id
        self.title = title
        self.date = date
        self.places = places
    }
}
