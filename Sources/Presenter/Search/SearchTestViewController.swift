//
//  SearchTestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class SearchTestViewController: BaseViewController {
    var viewModel: SearchTestViewModel?
    let courseTableView = CourseTableView()
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        return label
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        viewModel = SearchTestViewModel()
        viewModel!.$infos
            .sink(receiveValue: {
                self.courseTableView.infos = $0
            })
            .cancel(with: cancelBag)
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension SearchTestViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        view.backgroundColor = .black
        courseTableView.backgroundColor = .black
        view.addSubview(viewLabel)
        view.addSubview(courseTableView)
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubview(viewLabel)
        
//        viewLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
        
        courseTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(226)
            make.bottom.equalToSuperview()
        }
    }
}
