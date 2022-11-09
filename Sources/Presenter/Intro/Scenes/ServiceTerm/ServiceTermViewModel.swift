//
//  ServiceTermViewModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation
import CancelBag

protocol ServiceTermCoordinatorLogic {
    func coordinateToCreatePlanetScene()
    func coordinateToSignUpEnterNicknameScene(type: SignUpEnterNicknameViewModel.SignUpType)
}

protocol ServiceTermViewBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func checkButton1DidTapped()
    func checkButton2DidTapped()
    func checkButton3DidTapped()
    func checkButton4DidTapped()
}

final class ServiceTermViewModel: BaseViewModel, ServiceTermViewBusinessLogic {

    let coordinator: ServiceTermCoordinatorLogic

    private let signUpService = SignUpService()

    let type: SignUpEnterNicknameViewModel.SignUpType
    @Published var isChecked: [Bool] = Array.init(repeating: false, count: 4)

    init(
        type: SignUpEnterNicknameViewModel.SignUpType,
        coordinator: ServiceTermCoordinatorLogic
    ) {
        self.type = type
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.coordinator.coordinateToSignUpEnterNicknameScene(type: self.type)
        }
    }

    func checkButton1DidTapped() {
        isChecked[0].toggle()
        isChecked = Array.init(repeating: isChecked[0], count: 4)
    }

    func checkButton2DidTapped() {
        isChecked[1].toggle()
        checkAllButton()
    }

    func checkButton3DidTapped() {
        isChecked[2].toggle()
        checkAllButton()
    }

    func checkButton4DidTapped() {
        isChecked[3].toggle()
        checkAllButton()
    }

    private func checkAllButton() {
        isChecked[0] = isChecked[1] && isChecked[2] && isChecked[3]
    }

}
