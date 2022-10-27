//
//  IntroBaseViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

class IntroBaseViewController<VM: BusinessLogic>: UIViewController, CodeBased {

    let cancelBag = CancelBag()
    var viewModel: VM

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setAttribute()
        bind()
    }

    func bind() {}
    func setLayout() {}
    func setAttribute() {
        view.backgroundColor = .black
    }
}
