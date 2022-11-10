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
    
    private var dataSource: UITableViewDiffableDataSource<Int, Place>!
    private lazy var placeSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: -15, bottom: 0, right: 0)
        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.separatorColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
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
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, Place>()
                snapshot.appendSections([0])
                snapshot.appendItems(places)
                self.dataSource.apply(snapshot, animatingDifferences: true)
                
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
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension PlaceSearchViewController: NavigationBarConfigurable {
    private func setUI() {
        configureSearchNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)), mapAction: #selector(mapButtonPressed(_:)), textEditingAction: #selector(textFieldEditing(_:)))
        setBackgroundGyroMotion()
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenPressed(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        self.placeSearchTableView.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: PlaceSearchTableViewCell.identifier)
        
        self.dataSource = UITableViewDiffableDataSource<Int, Place>(tableView: self.placeSearchTableView, cellProvider: { tableView, indexPath, place -> UITableViewCell? in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceSearchTableViewCell.identifier, for: indexPath) as? PlaceSearchTableViewCell else { return nil }
            
            cell.titleLabel.text = place.title
            cell.addressLabel.text = place.address
            cell.categoryLabel.text = place.category
            cell.detailButton.tag = indexPath.row
            cell.detailButton.addTarget(self, action: #selector(self.detailButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        })
    }
    
    @objc
    private func textFieldEditing(_ sender: UITextField) {
        sender.textPublisher()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.viewModel.searchPlace(text)
            }
            .cancel(with: cancelBag)
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
extension PlaceSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        67
    }
}

// MARK: - User Interaction
extension PlaceSearchViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func mapButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func screenPressed(_ sender: UITapGestureRecognizer) {
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
    }
    
    @objc
    private func detailButtonPressed(_ sender: UIButton) {
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
    }
}
