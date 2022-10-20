//
//  BaseViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/11.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    let cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .designSystem(.black)                                // 화면 배경 색상을 설정합니다.
        navigationController?.interactivePopGestureRecognizer?.delegate = self      // Swipe-gesture를 통해 pop을 합니다.
    }
}
