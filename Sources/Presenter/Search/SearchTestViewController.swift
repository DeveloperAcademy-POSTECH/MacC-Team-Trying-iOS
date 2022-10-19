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
    private lazy var courseTableView = CourseTableView(viewModel: viewModel)
    private lazy var coursePlanetSegmentedControlView = CoursePlanetSegmentedControlView(buttonTitle: ["코스", "행성"])
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
//        viewModel = SearchTestViewModel()
   
        
//        viewModel!.$infos
//            .sink(receiveValue: {
//                self.courseTableView.infos = $0
//                self.courseTableView.reloadData()
//            })
//            .cancel(with: cancelBag)
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
        configure()
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
        view.addSubview(courseTableView)
        view.addSubview(coursePlanetSegmentedControlView)
        navigationController?.navigationBar.backgroundColor = .blue
    }
    
    private func setLayout() {
        
        coursePlanetSegmentedControlView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(23)
            make.top.equalToSuperview().inset(104)
        }
        
        courseTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(coursePlanetSegmentedControlView)
            make.top.equalTo(coursePlanetSegmentedControlView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configure() {
        
        coursePlanetSegmentedControlView.delegate = self
    }
}

extension SearchTestViewController: CoursePlanetSegmentSwitchable {
    func change(to coursePlanet: CoursePlanet) {
        guard let viewModel = viewModel else { return }
        viewModel.changeTo(coursePlanet)
    }
}
