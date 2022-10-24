//
//  PlaceListView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class PlaceListView: UIView {
    weak var parentView: UIView?
    var numberOfItems: Int
    var isContainerCollapsed = true                 // PlaceListContainerView가 펼쳐져있는지 접혀있는지 저장하는 변수입니다.
    private let minimumChangeValue: CGFloat = 50.0  // 최소로 움직여야 하는 값을 50으로 설정합니다.
    private var minHeight: CGFloat {
        switch numberOfItems {
        case 1:
            return 185
        case 2:
            return 252
        default:
            return 319
        }
    }
    
    private lazy var scrollIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .designSystem(.grayC5C5C5)
        return view
    }()
    lazy var mapPlaceTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MapPlaceTableViewCell.self, forCellReuseIdentifier: MapPlaceTableViewCell.identifier)
        tableView.backgroundColor = .designSystem(.black)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        tableView.separatorColor = .designSystem(.gray818181)
        if numberOfItems < 4 {
            tableView.isScrollEnabled = false
        }
        return tableView
    }()
    
    init(parentView: UIView, numberOfItems: Int) {
        self.parentView = parentView
        self.numberOfItems = numberOfItems
        super.init(frame: .zero)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension PlaceListView {
    private func setAttributes() {
        self.backgroundColor = .designSystem(.black)
        self.layer.cornerRadius = 20
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setLayout() {
        addSubviews(scrollIndicatorView, mapPlaceTableView)
        
        scrollIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview().inset(170)
            make.height.equalTo(5)
        }
        
        mapPlaceTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(98)
        }
    }
}

// MARK: - User Interaction
extension PlaceListView {
    @objc
    private func didPan(_ pan: UIPanGestureRecognizer) {
        guard let superView = superview else { return }
        let verticalTranslation = pan.translation(in: superView).y
        
        switch pan.state {
        case .changed:
            performGestureOnChange(verticalTranslation)
            
        case .ended:
            if isContainerCollapsed {
                guard verticalTranslation < 0 else { return }     // collapsed 상태에서 아래로 드래그하는 것을 무시합니다.
                if abs(verticalTranslation) < minimumChangeValue {
                    // 충분히 움직이지 않아 minHeight로 돌아갑니다.
                    animateToMinHeight()
                } else {
                    // 충분히 움직여 화면을 채우고 isContainerCollapsed의 값을 false로 설정합니다.
                    animateToFullScreen()
                    isContainerCollapsed.toggle()
                }
            } else {
                guard verticalTranslation > 0 else { return }     // full 상태에서 위로 드래그하는 것을 무시합니다.
                if abs(verticalTranslation) < minimumChangeValue {
                    // 충분히 움직이지 않아 full screen으로 돌아갑니다.
                    animateToFullScreen()
                } else {
                    // 충분히 움직여 높이를 minHeight로 설정하고 isContainerCollapsed의 값을 true로 설정합니다.
                    animateToMinHeight()
                    isContainerCollapsed.toggle()
                }
            }
           
        default:
            break
        }
    }
    
    /// Pan Gesture가 진행되는 상황에서 UI를 조정합니다.
    /// - Parameter verticalTranslation: 수직으로 움직인 거리
    private func performGestureOnChange(_ verticalTranslation: CGFloat) {
        guard let parentView = self.parentView else { return }
        if isContainerCollapsed {
            guard verticalTranslation < 0 else { return }     // collapsed 상태에서 아래로 드래그하는 것을 무시합니다.
            
            DispatchQueue.main.async {
                self.snp.remakeConstraints { make in
                    make.leading.trailing.bottom.equalToSuperview()
                    make.height.equalTo(self.minHeight - verticalTranslation)
                }
            }
        } else {
            guard verticalTranslation > 0 else { return }     // full 상태에서 위로 드래그하는 것을 무시합니다.
            
            DispatchQueue.main.async {
                self.snp.remakeConstraints { make in
                    make.leading.trailing.bottom.equalToSuperview()
                    make.top.equalTo(parentView.safeAreaLayoutGuide).offset(verticalTranslation)
                }
            }
        }
    }
    
    /// Place List View를 최소 높이로 보여줍니다.
    private func animateToMinHeight() {
        guard let parentView = self.parentView else { return }
        DispatchQueue.main.async {
            self.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(self.minHeight)
            }
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    parentView.layoutIfNeeded()
                }
            )
        }
    }
    
    /// Place List View를 최대 높이로 보여줍니다.
    private func animateToFullScreen() {
        guard let parentView = self.parentView else { return }
        DispatchQueue.main.async {
            self.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(parentView.safeAreaLayoutGuide).offset(10)
            }
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    parentView.layoutIfNeeded()
                }
            )
        }
    }
}
