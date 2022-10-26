//
//  Place.swift
//  MatStar
//
//  Created by uiskim on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import MapKit

struct Place {
    let title: String
    let category: String
    let address: String
    let location: CLLocationCoordinate2D
}

extension Place {
    static let firstDatePlaces = [
        Place(title: "포항공대", category: "대학교", address: "경북 포항시 남구 효리단길", location: CLLocationCoordinate2D(latitude: 36.01436040811483, longitude: 129.32476193278993)),
        Place(title: "효자초등학교", category: "초등학교", address: "경북 포항시 남구 이효리", location: CLLocationCoordinate2D(latitude: 36.00553989283799, longitude: 129.33772074559323)),
        Place(title: "포항종합운동장", category: "체육 시설", address: "경북 포항시 북구 양학동", location: CLLocationCoordinate2D(latitude: 36.00862889200349, longitude: 129.36398259910183))
    ]
    static let secondDatePlaces = [
        Place(title: "광안리해수욕장", category: "해수욕장", address: "부산 남구 대연동", location: CLLocationCoordinate2D(latitude: 35.15320527228295, longitude: 129.1189083767537)),
        Place(title: "H에비뉴호텔", category: "호텔", address: "서울특별시 어딘가", location: CLLocationCoordinate2D(latitude: 35.153193894044534, longitude: 129.12470143429098)),
        Place(title: "널구지공원", category: "공원", address: "충북 서산시 어딘가", location: CLLocationCoordinate2D(latitude: 35.16319093471162, longitude: 129.1291314739054)),
        Place(title: "금련산", category: "산", address: "경북 포항시 북구 창포동", location: CLLocationCoordinate2D(latitude: 35.161204733671845, longitude: 129.09472209989778))
    ]
}
