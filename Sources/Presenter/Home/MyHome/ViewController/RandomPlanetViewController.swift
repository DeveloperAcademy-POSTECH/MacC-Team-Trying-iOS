//
//  RandomPlanetViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/26.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

final class RandomPlanetViewController: BaseViewController {
    
    var randomPlanet: Planet? {
        didSet {
            guard let planet = randomPlanet else { return }
            randomPlanetImage.image = planet.planetTyle.planetImage
            randomPlanetLabel.text = planet.createdDate
            self.title = planet.name
        }
    }
    
    lazy var randomPlanetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var randomPlanetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textAlignment = .center
        label.backgroundColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(randomPlanetImage)
        view.addSubview(randomPlanetLabel)
        randomPlanetImage.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(DeviceInfo.screenWidth * 1.2)
        }
        
        randomPlanetLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.leading.right.equalToSuperview()
        }
        setNavigationBar()
    }
    
    func setNavigationBar() {
        // MARK: 네비게이션 title의 font변경
//        self.title = "내 별자리"
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

}
