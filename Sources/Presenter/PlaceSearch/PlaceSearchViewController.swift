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
    var viewModel: PlaceSearchViewModel?
    
    private lazy var placeTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        tableView.backgroundColor = .black
        tableView.sectionHeaderHeight = 1
        tableView.allowsSelection = false
        return tableView
    }()
    private lazy var emptyResultView = EmptyResultView()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setUI()
        bind()
    }
}

// MARK: - UI
extension PlaceSearchViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubview(placeTableView)
        
        placeTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        if let viewModel = viewModel, viewModel.places.isEmpty {
            self.presentEmptyResultView()
        }
    }
    
    private func presentEmptyResultView() {
        view.addSubview(emptyResultView)
        
        emptyResultView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(357)
            make.leading.trailing.equalToSuperview().inset(124)
        }
    }
}

// MARK: - UITableViewDataSource
extension PlaceSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as? PlaceTableViewCell else { return UITableViewCell() }
        let place = viewModel?.places[indexPath.row]
        cell.titleLabel.text = place?.title
        cell.addressLabel.text = place?.address
        cell.categoryLabel.text = place?.category
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlaceSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        return headerView
    }
}
