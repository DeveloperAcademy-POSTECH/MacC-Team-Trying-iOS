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

class BaseViewController: UIViewController {
    let cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 배경 색상 변경하기
        view.backgroundColor = .systemBackground
    }
}
