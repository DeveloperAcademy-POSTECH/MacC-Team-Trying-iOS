//
//  FeedMapViewController.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import MapKit

final class FeedMapViewController: BaseViewController {

    var viewModel: FeedViewModel?
    private var mapView = MKMapView()

    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetColor = .designSystem(Palette.black)
        view.barViewColor = .darkGray
        return view
      }()

    private let locationButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.designSystem(.mainYellow)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor.designSystem(.black)
        return button
    }()
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        mapView.delegate = self
        setAnnotation(latitude: 37.5030042, longtitude: 127.0507571)
    }
}

// TO DO: 수정해야함
extension FeedMapViewController: MKMapViewDelegate {

}

// MARK: - UI
extension FeedMapViewController: NavigationBarConfigurable {
    private func setUI() {
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        configureFeedMapNavigationBar(target: self, dissmissAction: #selector(backButtonPressed(_:)), selectSearchAction: #selector(searchButtonPressed(_:)))
        view.addSubviews(mapView, bottomSheetView, locationButton)
        navigationController?.tabBarController?.tabBar.isHidden = true
        mapView.delegate = self
        view.sendSubviewToBack(self.bottomSheetView.bottomSheetView)

    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(bottomSheetView.bottomSheetView.snp.top).offset(-20)
            make.trailing.equalToSuperview().inset(20)
        }
        mapView.snp.makeConstraints { make in
            make.center.width.height.equalToSuperview()
        }
        bottomSheetView.snp.makeConstraints { make in
            make.center.width.height.equalToSuperview()
        }
    }
}

extension FeedMapViewController {

    private func setAnnotation(latitude: CGFloat, longtitude: CGFloat) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.title = "HI"
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    @objc
    func backButtonPressed(_ sender: UIButton) {
        print("backButton Pressed")
    }

    @objc
    func searchButtonPressed(_ sender: UIButton) {
        print("searchButton Pressed")
    }

    @objc
    func locationButtonPressed(_ sender: UIButton) {
        print("locationButtonPressed Pressed")
    }
}
