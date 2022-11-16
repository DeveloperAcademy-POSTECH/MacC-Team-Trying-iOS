//
//  MyConstellationViewController.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class MyConstellationViewController: BaseViewController {

    var courses = [TestCourse]()
    
    lazy var myConstellationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (DeviceInfo.screenWidth - 40 - 10) / 2, height: 225)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
    }
}

// MARK: - UI
extension MyConstellationViewController {
    private func setUI() {
        view.addSubview(myConstellationCollectionView)
        myConstellationCollectionView.register(MyConstellationCollectionViewCell.self, forCellWithReuseIdentifier: MyConstellationCollectionViewCell.cellId)
        myConstellationCollectionView.dataSource = self
        myConstellationCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    func setNavigationBar() {
        // MARK: 네비게이션 title의 font변경
        self.title = "내 별자리"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        // MARK: 네비게이션 rightbutton커스텀
        
        let configure = UIImage.SymbolConfiguration(pointSize: 23, weight: .light, scale: .default)
        
        let mapButton = UIButton(type: .custom)
        mapButton.setImage(UIImage(systemName: "map", withConfiguration: configure), for: .normal)
        mapButton.tintColor = .white
        mapButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backButton = UIButton(type: .custom)
        backButton.setImage( UIImage(systemName: "chevron.backward", withConfiguration: configure), for: .normal)
        backButton.tintColor = .white
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightBarButton = UIBarButtonItem(customView: mapButton)
        let leftBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // MARK: 네비게이션이 너무 위에 붙어있어서 height증가
        self.additionalSafeAreaInsets.top = 20
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension MyConstellationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyConstellationCollectionViewCell.cellId, for: indexPath) as? MyConstellationCollectionViewCell else { return UICollectionViewCell() }
        cell.course = courses[indexPath.row]
        return cell
    }
}
