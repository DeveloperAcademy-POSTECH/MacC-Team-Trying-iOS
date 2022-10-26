//
//  PlaceSearchViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class PlaceSearchViewController: BaseViewController {
    var viewModel: PlaceSearchViewModel
    
    private lazy var placeSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: PlaceSearchTableViewCell.identifier)
        tableView.backgroundColor = .designSystem(.black)
        tableView.sectionHeaderHeight = 1
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var emptyResultView = EmptyResultView()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        viewModel.$places
            .receive(on: DispatchQueue.main)
            .sink { [weak self] places in
                guard let self = self else { return }
                if places.isEmpty {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.presentEmptyResultView()
                } else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.hideEmptyResultView()
                }
                self.placeSearchTableView.reloadData()
            }
            .cancel(with: cancelBag)
    }
    
    init(viewModel: PlaceSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .designSystem(.black)
        setUI()
        bind()
    }
}

// MARK: - UI
extension PlaceSearchViewController: NavigationBarConfigurable {
    private func setUI() {
        configureSearchNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)), doneAction: #selector(doneButtonPressed(_:)), textEditingAction: #selector(textFieldEditing(_:)))
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenPressed(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func textFieldEditing(_ sender: UITextField) {
        viewModel.searchPlace(sender.text ?? "")
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubview(placeSearchTableView)
        
        placeSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func presentEmptyResultView() {
        view.addSubview(emptyResultView)
        
        emptyResultView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(357)
            make.leading.trailing.equalToSuperview().inset(124)
        }
    }
    
    private func hideEmptyResultView() {
        emptyResultView.removeFromSuperview()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PlaceSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceSearchTableViewCell.identifier, for: indexPath) as? PlaceSearchTableViewCell else { return UITableViewCell() }
        let place = viewModel.places[indexPath.row]
        cell.titleLabel.text = place.title
        cell.addressLabel.text = place.address
        cell.categoryLabel.text = place.category
        cell.addCourseButton.tag = indexPath.row
        
        cell.addCourseButton.addTarget(self, action: #selector(addCourseButtonPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        67
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        return headerView
    }
}

// MARK: - User Interaction
extension PlaceSearchViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func doneButtonPressed(_ sender: UIButton) {
        // TODO: 완료 처리하기
        viewModel.pop()
    }
    
    @objc
    private func screenPressed(_ sender: UITapGestureRecognizer) {
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
    }
    
    @objc
    private func addCourseButtonPressed(_ sender: UIButton) {
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
        viewModel.addCourse(sender.tag)
    }
}
