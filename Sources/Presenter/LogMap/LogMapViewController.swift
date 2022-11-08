//
//  LogMapViewController.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import MapKit
import UIKit

import CancelBag
import SnapKit

final class LogMapViewController: BaseViewController {
    private let viewModel: LogMapViewModel
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = .infinity
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        manager.startMonitoringSignificantLocationChanges()
        return manager
    }()
    
    var currentLocation: CLLocation!
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.Image.navBarDeleteButton), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.register(StarAnnotationView.self, forAnnotationViewWithReuseIdentifier: StarAnnotationView.identifier)
        map.register(ConstellationAnnotationView.self, forAnnotationViewWithReuseIdentifier: ConstellationAnnotationView.identifier)
        map.delegate = self
        map.addAnnotations(viewModel.fetchAnnotations())
        map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
        map.showsUserLocation = true
        map.setUserTrackingMode(.followWithHeading, animated: true)
        return map
    }()
    
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton()
        button.mapView = mapView
        button.backgroundColor = .designSystem(.gray252632)
        button.tintColor = .designSystem(.mainYellow)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let ticketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Image.ticketIcon)
        return imageView
    }()
    private lazy var recordButton: UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "별자리 후기", attributes: [.font: UIFont.designSystem(weight: .bold, size: ._13)])
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.setAttributedTitle(title, for: .normal)
        button.layer.cornerRadius = 17
        button.setTitleColor(.designSystem(.mainYellow), for: .normal)
        button.backgroundColor = .designSystem(.black)
        button.layer.borderColor = .designSystem(.mainYellow)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(recordButtonPressed(_:)), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }
    
    init(viewModel: LogMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: 탭바 코드 삭제하기
        navigationController?.tabBarController?.tabBar.isHidden = true
        currentLocation = locationManager.location
        
        setUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "Error", message: "위치 서비스 기능이 꺼져있습니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                currentLocation = locationManager.location
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "위치 서비스 제공을 할 수 없습니다.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UI
extension LogMapViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        mapView.addSubview(userTrackingButton)
        recordButton.addSubview(ticketImageView)
        
        view.addSubviews(
            mapView,
            dismissButton,
            recordButton
        )
        
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        userTrackingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20)
        }
        
        ticketImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(110)
            make.height.equalTo(34)
        }
    }
}

// MARK: - MKMapViewDelegate
extension LogMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StarAnnotation {
            
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StarAnnotationView.identifier) else { return nil }
            
            annotationView.clusteringIdentifier = annotation.courseTitle
            annotationView.annotation = annotation
            annotationView.image = UIImage(named: Constants.Image.starAnnotation)
            
            return annotationView
            
        } else if let cluster = annotation as? MKClusterAnnotation {
            
            guard let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: ConstellationAnnotationView.identifier) else { return nil }
            
            clusterView.annotation = cluster
            clusterView.image = UIImage(named: "mock_cluster")
            
            return clusterView
            
        } else {
            return nil
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LogMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        currentLocation = locationManager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            self.currentLocation = locationManager.location
        case .authorizedAlways:
            self.currentLocation = locationManager.location
        case .restricted :
            break
        case .denied :
            break
        default:
            break
        }
    }
}

// MARK: - User Interactions
extension LogMapViewController {
    @objc
    private func dismissButtonPressed(_ sender: UIButton) {
        // TODO: dismiss
    }
    
    @objc
    private func recordButtonPressed(_ sender: UIButton) {
        // TODO: record button pressed
    }
}
