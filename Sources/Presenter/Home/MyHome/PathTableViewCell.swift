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
    func showActionSheet(alert: UIAlertController)
}

enum NavigationError: String, Error {
    case encodeError = "인코딩 오류입니다"
    case urlError = "url변환 오류입니다"
    
    var printErrorMessage: Void {
        switch self {
        case .encodeError:
            print(NavigationError.encodeError.rawValue)
        case .urlError:
            print(NavigationError.urlError.rawValue)
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
        contentView.addSubview(findPathButton)
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(70)
            make.height.equalTo(15)
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
            make.leading.equalToSuperview().inset(48)
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
        let encodeUrl = data.title.encodeUrl()
        guard let encodeUrl = encodeUrl else {
            NavigationError.encodeError.printErrorMessage
            return
        }
        
        let actionSheet = UIAlertController(title: "뭐로이동하시는데요?", message: "차량으로 이동할건가요 도보로이동할건가요?", preferredStyle: .actionSheet)
        let drivePath = UIAlertAction(title: "차량으로 이동", style: .default) { _ in

            let url = URL(string: "nmap://navigation?dlat=\(data.location.latitude)&dlng=\(data.location.longitude)&dname=\(encodeUrl)&appname=com.example.myapp")
            guard let url = url else {
                NavigationError.urlError.printErrorMessage
                return
            }
            
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
            } else {
              UIApplication.shared.open(appStoreURL)
            }
        }
        
        let walkPath = UIAlertAction(title: "도보로 이동", style: .default) { _ in
            let url = URL(string: "nmap://route/walk?dlat=\(data.location.latitude)&dlng=\(data.location.longitude)&dname=\(encodeUrl)&appname=com.example.myapp")
            guard let url = url else {
                print("url 변환 오류")
                return
            }
            
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
            } else {
              UIApplication.shared.open(appStoreURL)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(drivePath)
        actionSheet.addAction(walkPath)
        actionSheet.addAction(cancel)
        
        self.delegate?.showActionSheet(alert: actionSheet)
    }
    
    @objc
    func findPathButtonTapped() {
        showActionSheet()
    }
}
