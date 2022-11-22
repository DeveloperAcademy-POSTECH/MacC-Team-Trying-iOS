//
//  CourseTableViewCell.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import CoreLocation

protocol ActionSheetDelegate: AnyObject {
    func showPathActionSheet(alert: UIAlertController)
    func showSettingActionSheet(alert: UIAlertController)
    func presentModifyViewController()
    func presentRegisterReviewViewController()
    func deleteSelectedCourse()
    func reloadHomeView()
}

enum PathType {
    case Car
    case Walk
    case PublicTransfer
    
    var parameter: String {
        switch self {
        case .Car:
            return "navigation"
        case .Walk:
            return "route/walk"
        case .PublicTransfer:
            return "route/public"
        }
    }
}

enum NavigationError: String, Error {
    case encodeError = "인코딩 오류입니다"
    case urlError = "url변환 오류입니다"
    
    var printErrorMessage: String {
        switch self {
        case .encodeError:
            return NavigationError.encodeError.rawValue
        case .urlError:
            return NavigationError.urlError.rawValue
        }
    }
}

class PathTableViewCell: UITableViewCell {
    
    static let cellId = "PathTableViewCell"
    
    weak var delegate: ActionSheetDelegate?
    
    var data: DatePath? {
        didSet {
            guard let data = data else { return }
            title.text = data.title
            comment.text = data.comment
            guard let distance = data.distance else { return }
            self.distance.text = distance.changeDistance()
        }
    }
    
    let title: UILabel = {
        let v = UILabel()
        v.font = UIFont.gmarksans(weight: .medium, size: ._13)
        v.textColor = .white
        return v
    }()
    
    let comment: UILabel = {
        let v = UILabel()
        v.font = UIFont.gmarksans(weight: .light, size: ._10)
        v.textColor = .white
        return v
    }()
    
    let distance: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 10, weight: .regular)
        v.textColor = .white.withAlphaComponent(0.5)
        return v
    }()
    
    let pointCircle: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "PathPoint")
        return v
    }()
    
    let lineUpper: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let lineLower: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var findPathButton: UIButton = {
        let v = UIButton(type: .custom)
        v.setImage(UIImage(named: "FindPathButton"), for: .normal)
        v.addTarget(self, action: #selector(findPathButtonTapped), for: .touchUpInside)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubviews(title, comment, distance, pointCircle, lineUpper, lineLower)
        // MARK: - addSubView를 하면 터치가 안되는 문제가 발생해 contentView위에다가 addsubView를 해줌
        contentView.addSubview(findPathButton)
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(70)
            make.height.equalTo(15)
            make.width.equalTo(150)
        }
        
        comment.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.leading.equalTo(title.snp.leading)
            make.height.equalTo(12)
        }
        
        distance.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
        pointCircle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(53)
            make.size.equalTo(12)
        }
        
        lineUpper.snp.makeConstraints { make in
            make.width.equalTo(1.5)
            make.centerX.equalTo(pointCircle.snp.centerX)
            make.top.equalToSuperview()
            make.bottom.equalTo(pointCircle.snp.centerY)
        }
        
        lineLower.snp.makeConstraints { make in
            make.width.equalTo(1.5)
            make.centerX.equalTo(pointCircle.snp.centerX)
            make.top.equalTo(pointCircle.snp.centerY)
            make.bottom.equalToSuperview()
        }
        
        findPathButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(20)
            make.centerY.equalTo(pointCircle.snp.centerY)
        }
    }
    
    func showActionSheet() {
        guard let data = self.data else { return }
        let actionSheet = UIAlertController(title: nil, message: "이동수단을 선택해주세요!", preferredStyle: .actionSheet)
        let drivePath = UIAlertAction(title: "차량으로 이동", style: .default) { _ in
            self.moveToNaverMap(pathType: .Car, data: data)
        }
        let walkPath = UIAlertAction(title: "걸어서 이동", style: .default) { _ in
            self.moveToNaverMap(pathType: .Walk, data: data)
        }
        let publicPath = UIAlertAction(title: "대중교통으로 이동", style: .default) { _ in
            self.moveToNaverMap(pathType: .PublicTransfer, data: data)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(walkPath)
        actionSheet.addAction(publicPath)
        actionSheet.addAction(drivePath)
        actionSheet.addAction(cancel)
        self.delegate?.showPathActionSheet(alert: actionSheet)
    }
    
    /// 버튼을 누르면 naverMap으로 이동시켜주는(URL Scheme)함수
    /// - Parameters:
    ///   - pathType: 도보이동 정보를 보여줄지, 자가이동 정보를 보여줄지, 대중교통이동 정보를 보여줄지를 선택
    ///   - data: 내가 가고자하는 곳의 장소데이터
    func moveToNaverMap(pathType: PathType, data: DatePath) {
        let id = "appname=com.example.myapp"
        let encoder = data.title.encodeUrl()
        guard let encoder = encoder else {
            print(NavigationError.encodeError.printErrorMessage)
            return
        }
        
        let url = URL(string: "nmap://\(pathType.parameter)?dlat=\(data.location.latitude)&dlng=\(data.location.longitude)&dname=\(encoder)&\(id)")
        guard let url = url else {
            print(NavigationError.urlError.printErrorMessage)
            return
        }
        
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        } else {
          UIApplication.shared.open(appStoreURL)
        }
    }
    
    @objc
    func findPathButtonTapped() {
        showActionSheet()
    }
}
