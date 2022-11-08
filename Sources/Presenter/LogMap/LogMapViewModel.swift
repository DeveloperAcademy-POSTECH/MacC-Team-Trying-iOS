//
//  LogMapViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import CancelBag

final class LogMapViewModel: BaseViewModel {
    private let coordinator: Coordinator
    private let mockCourseData: [Course] = [
        Course(
            belongedPlanet: Planet(
                planetId: 0,
                name: "",
                planetTyle: .blue,
                createdDate: ""
            ),
            title: "Busan",
            content: "",
            date: "",
            tags: [],
            images: [],
            places: [
                Place(
                    title: "광안리 할리스 커피",
                    category: "카페",
                    address: "부산광역시 남구 남천동",
                    location: CLLocationCoordinate2D(
                        latitude: 36.03549980068982,
                        longitude: 129.3612419706613
                    )
                ),
                Place(
                    title: "모모 커피",
                    category: "카페",
                    address: "부산광역시 남구 대연동",
                    location: CLLocationCoordinate2D(
                        latitude: 36.03624624575639,
                        longitude: 129.36739581681525
                    )
                ),
                Place(
                    title: "롯데백화점",
                    category: "백화점",
                    address: "부산광역시 남포동",
                    location: CLLocationCoordinate2D(
                        latitude: 36.03800865742448,
                        longitude: 129.36472060287912
                    )
                ),
                Place(
                    title: "원조국밥",
                    category: "음식점",
                    address: "하단",
                    location: CLLocationCoordinate2D(
                        latitude: 36.04359973388279,
                        longitude: 129.36772915014853
                    )
                )
            ]
        ),
        Course(
            belongedPlanet: Planet(
                planetId: 0,
                name: "",
                planetTyle: .blue,
                createdDate: ""
            ),
            title: "Pohang",
            content: "",
            date: "",
            tags: [],
            images: [],
            places: [
                Place(
                    title: "스타벅스",
                    category: "카페",
                    address: "경북 포항시 중앙로",
                    location: CLLocationCoordinate2D(
                        latitude: 36.03536405838777,
                        longitude: 129.36736639219797
                    )
                ),
                Place(
                    title: "요신의 하루",
                    category: "카페",
                    address: "경북 포항시 남구",
                    location: CLLocationCoordinate2D(
                        latitude: 36.040404133657894,
                        longitude: 129.36863804148666
                    )
                ),
                Place(
                    title: "킹신의 하루",
                    category: "카페",
                    address: "경북 포항시 남구",
                    location: CLLocationCoordinate2D(
                        latitude: 36.03962955018123,
                        longitude: 129.36428042810493
                    )
                )
            ]
        ),
        Course(
            belongedPlanet: Planet(
                planetId: 0,
                name: "",
                planetTyle: .blue,
                createdDate: ""
            ),
            title: "Changwon",
            content: "",
            date: "",
            tags: [],
            images: [],
            places: [
                Place(
                    title: "도자캣",
                    category: "카페",
                    address: "서울특별시",
                    location: CLLocationCoordinate2D(
                        latitude: 36.03065601764658,
                        longitude: 129.3649814772948
                    )
                ),
                Place(
                    title: "테일러",
                    category: "영화관",
                    address: "서울특별시",
                    location: CLLocationCoordinate2D(
                        latitude: 36.02769615590364,
                        longitude: 129.36180334822487
                    )
                ),
                Place(
                    title: "아리아나",
                    category: "음식점",
                    address: "서울특별시",
                    location: CLLocationCoordinate2D(
                        latitude: 36.0289843866854,
                        longitude: 129.35603590445635
                    )
                ),
                Place(
                    title: "위켄드",
                    category: "미술관",
                    address: "서울특별시",
                    location: CLLocationCoordinate2D(
                        latitude: 36.02310697203816,
                        longitude: 129.35551636549832
                    )
                )
            ]
        )
    ]
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Business Logic
extension LogMapViewModel {
    func fetchCourses() -> [Course] {
        self.mockCourseData
    }
    
    func fetchAnnotations() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        mockCourseData.forEach { course in
            course.places.forEach { place in
                annotations.append(convertToAnnotation(courseTitle: course.title, place: place))
            }
        }
        return annotations
    }
}

// MARK: - Helper
extension LogMapViewModel {
    private func convertToAnnotation(courseTitle: String, place: Place) -> MKAnnotation {
        StarAnnotation(courseTitle: courseTitle, coordinate: place.location)
    }
}
