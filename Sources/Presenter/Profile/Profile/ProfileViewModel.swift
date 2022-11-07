//
//  ProfileViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

final class ProfileViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    // FIXME: Data binding
    @Published var numberOfPlaces: Int = 249
    @Published var numberOfCities: Int = 60
    @Published var planetImageName: String = "planet_purple"
    @Published var planetName: String = "찰리"
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
