//
//  PlaceSearchViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import UIKit

import CancelBag
import SnapKit

protocol PlacePresenting: AnyObject {
    /// 겸색 결과로 나온 장소의 위치를 지도에서 보여줍니다.
    /// - Parameter place: 선택한 장소
    func presentSelectedPlace(place: Place)
    
    /// 검색 결과로 나온 여러 장소들의 위치를 지도에서 보여줍니다.
    /// - Parameter places: 검색 결과로 나온 여러 장소들
    func presentSearchedPlaces(places: [Place])
}

final class PlaceSearchViewController: BaseViewController {
    private enum PlaceSearchTableSection {
        case main
    }
    
    var searchText: String = ""
    var viewModel: PlaceSearchViewModel
    
    private var dataSource: UITableViewDiffableDataSource<PlaceSearchTableSection, Place>!
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
        if let textField = self.navigationItem.leftBarButtonItem?.customView as? CustomTextField {
            textField.textPublisher()
                .debounce(for: 0.3, scheduler: RunLoop.main)
                .sink { [weak self] text in
                    guard let self = self else { return }
                    self.searchText = text
                    Task {
                        try await self.viewModel.searchPlace(query: text)
                    }
                }
                .cancel(with: cancelBag)
        }
        
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
                
                var snapshot = NSDiffableDataSourceSnapshot<PlaceSearchTableSection, Place>()
                snapshot.appendSections([.main])
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentKeyboard()
    }
}

// MARK: - UI
extension PlaceSearchViewController: NavigationBarConfigurable {
    private func setUI() {
        configureSearchNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)), mapAction: #selector(mapButtonPressed(_:)))
        setBackgroundGyroMotion()
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenPressed(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        self.placeSearchTableView.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: PlaceSearchTableViewCell.identifier)
        
        self.dataSource = UITableViewDiffableDataSource<PlaceSearchTableSection, Place>(tableView: self.placeSearchTableView, cellProvider: { tableView, indexPath, place -> UITableViewCell? in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceSearchTableViewCell.identifier, for: indexPath) as? PlaceSearchTableViewCell else { return nil }
            
            cell.configure(place)
            cell.detailButton.tag = indexPath.row
            cell.detailButton.addTarget(self, action: #selector(self.detailButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        })
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
    
    private func presentKeyboard() {
        guard let textField = navigationItem.leftBarButtonItem?.customView as? CustomTextField else { return }
        textField.becomeFirstResponder()
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
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
        let places = viewModel.getPlaces()

        let averageLatitude = places.reduce(into: 0.0) { $0 += $1.location.latitude } / Double(places.count)
        let averageLongitude = places.reduce(into: 0.0) { $0 += $1.location.longitude } / Double(places.count)
        
        self.viewModel.pushToPlaceSearchResultMapView(searchText: searchText, searchedPlaces: places, presentLocation: CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude))
    }
    
    @objc
    private func screenPressed(_ sender: UITapGestureRecognizer) {
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
    }
    
    @objc
    private func detailButtonPressed(_ sender: UIButton) {
        navigationItem.leftBarButtonItem?.customView?.resignFirstResponder()
        
        let place = viewModel.getPlace(index: sender.tag)
        self.viewModel.pushToPlaceSearchResultMapView(searchText: searchText, searchedPlaces: [place], presentLocation: place.location)
    }
    
    @objc
    private func dismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
