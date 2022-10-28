//
//  CoursesViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/24.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class CoursesViewController: BaseViewController {
    
    var courses: [UserCourseInfo.Course?] = []
    
    lazy var courseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (DeviceInfo.screenWidth - 40 - 10) / 2, height: 225)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        // MARK: 네비게이션 title의 font변경
        self.title = "내 별자리"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        // MARK: 네비게이션 rightbutton커스텀
        let mapButton = UIButton(type: .custom)
        let configure = UIImage.SymbolConfiguration(pointSize: 23, weight: .light, scale: .default)
        mapButton.setImage(UIImage(systemName: "map", withConfiguration: configure), for: .normal)
        mapButton.tintColor = .white
        mapButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let rightBarButton = UIBarButtonItem(customView: mapButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: 네비게이션이 너무 위에 붙어있어서 height증가
        self.additionalSafeAreaInsets.top = 20
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUI() {
        view.addSubview(courseCollectionView)
        courseCollectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: CourseCollectionViewCell.cellId)
        courseCollectionView.dataSource = self
        courseCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

extension CoursesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.cellId, for: indexPath) as? CourseCollectionViewCell else { return UICollectionViewCell() }
        cell.course = courses[indexPath.row]
        return cell
    }
}
