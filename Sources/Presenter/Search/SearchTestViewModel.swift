//
//  SearchTestViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

final class SearchTestViewModel: BaseViewModel {
    
    @Published var infos: [Info] = []
//    
    override init() {
        super.init()
        fetchInfos()
    }
//    
    func fetchInfos() {

            self.infos = [Info(planetImageString: "YouthPlanet", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: false, isLike: true, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]), Info(planetImageString: "YouthPlanet", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: true, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]), Info(planetImageString: "YouthPlanet", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: true, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"])]

    }
}
