//
//  SearchViewController.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/20.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class SearchViewController: BaseViewController {
    var viewModel: SearchViewModel?
    private lazy var courseTableView = CourseTableView(viewModel: viewModel)
    private lazy var coursePlanetSegmentedControlView = CoursePlanetSegmentedControlView(buttonTitle: ["코스", "행성"])
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchNavigationBar(target: self, action: nil)
        setUI()
        bind()
        configure()
    }
}

// MARK: - UI
extension SearchViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    private func setAttributes() {
        view.backgroundColor = .black
        view.addSubview(courseTableView)
        view.addSubview(coursePlanetSegmentedControlView)
    }
    
    private func setLayout() {
        
        coursePlanetSegmentedControlView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
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
    
    private func configureSearchNavigationBar(target: Any?, action: Selector?) {
        let titleView = CustomTextField(type: .searchCourseAndPlanet)
        navigationItem.titleView = titleView
    }
    
}

extension SearchViewController: CoursePlanetSegmentSwitchable {
    func change(to coursePlanet: CoursePlanet) {
        guard let viewModel = viewModel else { return }
        viewModel.changeTo(coursePlanet)
    }
}
