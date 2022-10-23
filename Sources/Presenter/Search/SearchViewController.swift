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
    var cancelbag = Set<AnyCancellable>()
    private lazy var courseTableView = CourseTableView(viewModel: viewModel)
    private let coursePlanetSegmentedControlView = CoursePlanetSegmentedControlView(buttonTitles: ["코스", "행성"])
    private let navigationTextField = SearchTextField()
    
    private func bind() {
        viewModel?.bind(navigationTextField, to: \.searchString)
    }

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
        navigationItem.titleView = navigationTextField
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
}
