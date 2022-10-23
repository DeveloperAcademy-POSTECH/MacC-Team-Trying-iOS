//
//  AddCourseMapViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class AddCourseMapViewController: BaseViewController {
    var viewModel: AddCourseMapViewModel?

    private lazy var placeListView: PlaceListView = {
        let view = PlaceListView(parentView: self.view, numberOfItems: (viewModel?.places.count)!)
        view.mapPlaceTableView.dataSource = self
        view.mapPlaceTableView.delegate = self
        return view
    }()
    private lazy var nextButton = MainButton(type: .next)
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension AddCourseMapViewController: NavigationBarConfigurable {
    private func setUI() {
        configureMapNavigationBar(target: self, dismissAction: #selector(backButtonPressed(_:)), pushAction: #selector(nextButtonPressed(_:)))
        setAttributes()
        setLayout()
        
        // TODO: 배경 원상복구
        view.backgroundColor = .systemGray4
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        navigationController?.tabBarController?.tabBar.isHidden = true

        view.addSubviews(placeListView, nextButton)

        placeListView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            
            let numberOfItems = viewModel?.places.count
            switch numberOfItems {
                // 기본으로 줘야하는 높이 : 45
                // indicator 영역 높이 : 15
                // main button 높이 : 58
                // 위 3개는 최소 높이. (45 + 15 + 58 = 118)
                // 이후 셀 하나가 추가되는 만큼 셀 높이 추가해주기
                // 셀 하나의 높이 : 67
            case 0:
                placeListView.isHidden = true
                nextButton.isHidden = true
            case 1:
                make.height.equalTo(185)
            case 2:
                make.height.equalTo(252)
            default:
                make.height.equalTo(319)
            }
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddCourseMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapPlaceTableViewCell.identifier, for: indexPath) as? MapPlaceTableViewCell else { return UITableViewCell() }
        
        let place = viewModel?.places[indexPath.row]
        
        cell.numberLabel.text = String(indexPath.row + 1)
        cell.titleLabel.text = place?.title
        cell.categoryLabel.text = place?.category
        cell.addressLabel.text = place?.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        67
    }
}

// MARK: - User Interactions
extension AddCourseMapViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        print("pop")
    }
    
    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        print("next")
    }
}
