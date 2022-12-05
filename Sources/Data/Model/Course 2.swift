//
//  Course.swift
//  MatStar
//
//  Created by uiskim on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct Course {
    // 어느행성에 속해있는 Course인지 알려주는 변수
    let belongedPlanet: Planet
    let title: String
    let content: String
    // 생성날짜가 아닌 데이트를 한 날짜 -> DataPicker로 받아올 변수
    let date: String
    let tags: [Tag]
    let images: [CourseImage]
    let places: [Place]
}

//extension Course {
//    static let firstDateCoures = Course(belongedPlanet: User.testUser.myPlanet,
//                                        title: "포항풀코스",
//                                        content: "포항공대에서 데이트를 했다",
//                                        date: "2022년 10월 01일",
//                                        tags: Tag.firstDateTags,
//                                        images: CourseImage.firstDateCourseImages,
//                                        places: Place.firstDatePlaces)
//    
//    static let secondDateCourse = Course(belongedPlanet: User.testUser.myPlanet,
//                                         title: "부산풀코스",
//                                         content: "광안리에서 데이트를 했다",
//                                         date: "2022년 10월 05일",
//                                         tags: Tag.secondDateTags,
//                                         images: CourseImage.secondDateCourseImages,
//                                         places: Place.secondDatePlaces)
//}
