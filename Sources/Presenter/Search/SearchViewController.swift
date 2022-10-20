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
    private var coursePlanetSegmentedControlView = CoursePlanetSegmentedControlView(buttonTitles: ["코스", "행성"])

    private func bind() { }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        configure()
    }
}

// MARK: - UI
extension SearchViewController {
    private func setUI() {
        configureSearchNavigationBar(target: self, action: nil)
        setAttributes()
        setLayout()
    }
    
    private func setAttributes() {
        view.backgroundColor = .designSystem(.black)
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
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(coursePlanetSegmentedControlView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
            
    private func configure() {
        coursePlanetSegmentedControlView.segmentChanged = { [weak self] coursePlanet in
            guard let viewModel = self?.viewModel else { return }
            viewModel.changeTo(coursePlanet)
        }
    }
    
    private func configureSearchNavigationBar(target: Any?, action: Selector?) {
        let titleView = CustomTextField(type: .searchCourseAndPlanet)
        navigationItem.titleView = titleView
    }
}
