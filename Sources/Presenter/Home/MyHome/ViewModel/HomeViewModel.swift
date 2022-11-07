//
//  HomeViewModel.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

final class HomeViewModel: BaseViewModel {

    var coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
}
