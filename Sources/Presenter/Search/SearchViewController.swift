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
    
    var searchViewModel: SearchViewModel?
    private lazy var courseTableView = CourseTableView(viewModel: searchViewModel)
    private let coursePlanetSegmentedControlView = CoursePlanetSegmentedControlView(buttonTitles: ["코스", "행성"])
    private let navigationTextField = SearchTextField()
    
    private func bind() {
        searchViewModel?.bind(navigationTextField, to: \.searchString)
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
        setDoneOnKeyboard()
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
            guard let viewModel = self?.searchViewModel else { return }
            viewModel.changeTo(coursePlanet)
        }
    }
}

extension SearchViewController {
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let emptyView = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [emptyView, doneBarButton]
        self.navigationTextField.inputAccessoryView = keyboardToolbar
    }

    @objc
    func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }
}
