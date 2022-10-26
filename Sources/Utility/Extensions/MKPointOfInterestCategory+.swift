//
//  MKPointOfInterestCategory+.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import MapKit

extension MKPointOfInterestCategory {
    var koreanCategory: String {
        switch self.rawValue {
        case "MKPOICategoryAirport":
            return "공항"
        case "MKPOICategoryAmusementPark":
            return "놀이공원"
        case "MKPOICategoryAquarium":
            return "아쿠아리움"
        case "MKPOICategoryATM":
            return "ATM"
        case "MKPOICategoryBakery":
            return "베이커리"
        case "MKPOICategoryBank":
            return "은행"
        case "MKPOICategoryBeach":
            return "해변"
        case "MKPOICategoryBrewery":
            return "양조장"
        case "MKPOICategoryCafe":
            return "카페"
        case "MKPOICategoryCamparound":
            return "캠핑장"
        case "MKPOICategoryCarRental":
            return "렌트카"
        case "MKPOICategoryEvCharger":
            return "전기차 충전소"
        case "MKPOICategoryFireStation":
            return "소방서"
        case "MKPOICategoryFitnessCenter":
            return "헬스"
        case "MKPOICategoryFoodMarket":
            return "마켓"
        case "MKPOICategoryGasStation":
            return "주유소"
        case "MKPOICategoryHospital":
            return "병원"
        case "MKPOICategoryHotel":
            return "호텔"
        case "MKPOICategoryLaundry":
            return "세탁소"
        case "MKPOICategoryLibrary":
            return "도서관"
        case "MKPOICategoryMarina":
            return "항구"
        case "MKPOICategoryMovieTheater":
            return "영화관"
        case "MKPOICategoryMuseum":
            return "박물관"
        case "MKPOICategoryNationalPark":
            return "국립공원"
        case "MKPOICategoryNightLife":
            return "놀거리"
        case "MKPOICategoryPark":
            return "공원"
        case "MKPOICategoryParking":
            return "주차장"
        case "MKPOICategoryPharmacy":
            return "약국"
        case "MKPOICategoryPolice":
            return "경찰서"
        case "MKPOICategoryPostOffice":
            return "우체국"
        case "MKPOICategoryPublicTransport":
            return "대중교통"
        case "MKPOICategoryRestaurant":
            return "식당"
        case "MKPOICategoryRestroom":
            return "화장실"
        case "MKPOICategorySchool":
            return "학교"
        case "MKPOICategoryStadium":
            return "경기장"
        case "MKPOICategoryStore":
            return "매장"
        case "MKPOICategoryTheater":
            return "극장"
        case "MKPOICategoryUniversity":
            return "대학교"
        case "MKPOICategoryWinery":
            return "와인 농장"
        case "MKPOICategoryZoo":
            return "동물원"
        default:
            return ""
        }
    }
}
