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
    enum PlaceListViewStatus {
        case collapsed
        case medium
        case full
    }
    
    private enum PlaceListMediumHeight: CGFloat {
        case zero
        case one
        case two
        case moreThanThree
        
        var height: CGFloat {
            // 기본으로 줘야하는 높이 : 45
            // indicator 영역 높이 : 15
            // headerView로 사용되는 label의 높이 : 40
            // main button 높이 : 58
            // 위 3개는 최소 높이. (45 + 15 + 58 = 118)
            // 이후 셀 하나가 추가되는 만큼 셀 높이 추가해주기
            // 셀 하나의 높이 : 67
            switch self {
            case .zero:
                return 0
            case .one:
                return 225
            case .two:
                return 292
            case .moreThanThree:
                return 359
            }
        }
    }
    
    weak var parentView: UIView?
    var placeListViewStatus: PlaceListViewStatus = .medium
    var numberOfItems: Int = 0 {
        didSet {
            switch numberOfItems {
            case 0:
                self.mediumHeight = .zero
                self.height = 0
            case 1:
                self.mediumHeight = .one
                if placeListViewStatus == .medium {
                    self.height = 225
                }
            case 2:
                self.mediumHeight = .two
                if placeListViewStatus == .medium {
                    self.height = 292
                }
            default:
                self.mediumHeight = .moreThanThree
                if placeListViewStatus == .medium {
                    self.height = 359
                }
            }
            
            if numberOfItems > 3 {
                self.mapPlaceTableView.isScrollEnabled = true
            } else {
                self.mapPlaceTableView.isScrollEnabled = false
            }
        }
    }
    private let minimumChangeValue: CGFloat = 50.0  // 최소로 움직여야 하는 값을 50으로 설정합니다.
    private let collapsedHeight: CGFloat = 225
    private var mediumHeight: PlaceListMediumHeight = .zero
    private let fullHeight: CGFloat = DeviceInfo.screenHeight * 0.8767
    var height: CGFloat = 0
    
    private lazy var scrollIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .designSystem(.grayC5C5C5)
        return view
    }()
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "")
        let firstString = NSAttributedString(string: "방문 장소를", attributes: [.font: UIFont.designSystem(weight: .bold, size: ._15), .foregroundColor: UIColor.designSystem(.white)!])
        let secondString = NSAttributedString(string: " 순서대로", attributes: [.font: UIFont.designSystem(weight: .bold, size: ._15), .foregroundColor: UIColor.designSystem(.mainYellow)!])
        let thirdString = NSAttributedString(string: " 추가해주세요", attributes: [.font: UIFont.designSystem(weight: .bold, size: ._15), .foregroundColor: UIColor.designSystem(.white)!])
        attributedString.append(firstString)
        attributedString.append(secondString)
        attributedString.append(thirdString)
        label.attributedText = attributedString
        return label
    }()
    lazy var mapPlaceTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MapPlaceTableViewCell.self, forCellReuseIdentifier: MapPlaceTableViewCell.identifier)
        tableView.backgroundColor = .designSystem(.black)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        tableView.separatorColor = .designSystem(.gray818181)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    init(parentView: UIView) {
        self.parentView = parentView
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
        addSubviews(
            scrollIndicatorView,
            viewLabel,
            mapPlaceTableView
        )
        
        scrollIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview().inset(170)
            make.height.equalTo(5)
        }
        
        viewLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollIndicatorView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        mapPlaceTableView.snp.makeConstraints { make in
            make.top.equalTo(viewLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(98)
        }
    }
    
    /// placeListViewStatus와 height를 설정하고 해당 높이로 애니메이션을 보여줍니다.
    /// - Parameter viewStatus: 보여줄 PlaceListViewStatus (.collapsed, .medium, .full)
    private func display(mode viewStatus: PlaceListViewStatus) {
        if self.placeListViewStatus != viewStatus {
            self.placeListViewStatus = viewStatus
        }
        
        switch viewStatus {
        case .collapsed:
            self.height = collapsedHeight
        case .medium:
            self.height = mediumHeight.height
        case .full:
            self.height = fullHeight
        }
        
        guard let parentView = self.parentView else { return }
        
        DispatchQueue.main.async {
            self.snp.updateConstraints { make in
                make.height.equalTo(self.height)
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

// MARK: - BottomHidable
extension PlaceListView: BottomHidable {
    func hide() {
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(-height)
        }
    }
    
    func present() {
        self.snp.updateConstraints { make in
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
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
            switch placeListViewStatus {
            case .collapsed:
                guard verticalTranslation < 0 else { return }   // collapsed 상태에서 아래로 드래그하는 것을 무시합니다.
                if abs(verticalTranslation) < minimumChangeValue {
                    // 충분히 움직이지 않아 높이를 collapsedHeight로 설정하고 애니메이션을 보여줍니다.
                    display(mode: .collapsed)
                } else {
                    // 위로 충분히 움직여 높이를 mediumHeight로 설정하고 애니메이션을 보여줍니다.
                    display(mode: .medium)
                }
                
            case .medium:
                if abs(verticalTranslation) < minimumChangeValue {
                    // 충분히 움직이지 않아 높이를 mediumHeight로 설정하고 애니메이션을 보여줍니다.
                    display(mode: .medium)
                } else {
                    if verticalTranslation > minimumChangeValue {
                        // 아래로 충분히 움직여 높이를 collapsedHeight로 설정하고 애니메이션을 보여줍니다.
                        display(mode: .collapsed)
                    } else {
                        // 위로 충분히 움직여 높이를 fullHeight로 설정하고 애니메이션을 보여줍니다.
                        display(mode: .full)
                    }
                }
                
            case .full:
                guard verticalTranslation > 0 else { return }   // full 상태에서 위로 드래그하는 것을 무시합니다.
                if abs(verticalTranslation) < minimumChangeValue {
                    // 충분히 움직이지 않아 높이를 fullHeight로 설정하고 애니메이션을 보여줍니다.
                    display(mode: .full)
                } else {
                    // 아래로 충분히 움직여 높이를 mediumHeight로 설정하고 애니메이션을 보여줍니다.
                    display(mode: .medium)
                }
            }
           
        default:
            break
        }
    }
    
    /// Pan Gesture가 진행되는 상황에서 UI를 조정합니다.
    /// - Parameter verticalTranslation: 수직으로 움직인 거리
    private func performGestureOnChange(_ verticalTranslation: CGFloat) {
        guard self.placeListViewStatus == .collapsed && verticalTranslation < 0 ||
                self.placeListViewStatus == .medium ||
                self.placeListViewStatus == .full && verticalTranslation > 0 else { return }
        
        DispatchQueue.main.async {
            self.snp.updateConstraints { make in
                make.height.equalTo(self.height - verticalTranslation)
            }
        }
    }
}
