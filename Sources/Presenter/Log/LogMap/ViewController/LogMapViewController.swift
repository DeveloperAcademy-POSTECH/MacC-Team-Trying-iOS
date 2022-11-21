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
    private enum DismissButtonType {
        case dismiss
        case pop
    }
    
    var viewModel: LogMapViewModel
    private let locationManager = LocationManager.shared
    
    private lazy var dismissButton = UIButton()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.register(StarAnnotationView.self, forAnnotationViewWithReuseIdentifier: StarAnnotationView.identifier)
        map.register(ConstellationAnnotationView.self, forAnnotationViewWithReuseIdentifier: ConstellationAnnotationView.identifier)
        map.delegate = self
        map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: locationManager.latitude,
                    longitude: locationManager.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
        map.showsUserLocation = true
        map.setUserTrackingMode(.follow, animated: true)
        map.showsCompass = false
        return map
    }()
    
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton()
        button.mapView = mapView
        button.backgroundColor = .designSystem(.gray252632)
        button.tintColor = .designSystem(.mainYellow)
        button.layer.cornerRadius = 5
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
        
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - UI
extension LogMapViewController {
    private func setUI() {
        presentConstellationAnnotations()
        setDismissButton(type: .dismiss)
        setLayout()
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(-80)
            make.width.equalTo(110)
            make.height.equalTo(34)
        }
    }
    
    private func presentConstellationAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel.fetchConstellationAnnotations())
    }
    
    private func presentStarAnnotations(selectedCourseID: Int) {
        mapView.removeAnnotations(mapView.annotations)
        let starAnnotations = viewModel.fetchStarAnnotations(with: selectedCourseID)
        mapView.addAnnotations(starAnnotations)
        mapView.showAnnotations(starAnnotations, animated: true)
    }
    
    private func presentRecordButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.recordButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            }
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    private func dismissRecordButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.recordButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(-80)
            }
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    private func setDismissButton(type: DismissButtonType) {
        switch type {
        case .dismiss:
            dismissButton.setImage(UIImage(named: Constants.Image.navBarDeleteButton), for: .normal)
            dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
            
        case .pop:
            dismissButton.setImage(UIImage(named: Constants.Image.navBarPopButton), for: .normal)
            dismissButton.addTarget(self, action: #selector(popButtonPressed(_:)), for: .touchUpInside)
        }
    }
    
    private func presentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, span: Double) {
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: spanValue), animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension LogMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let starAnnotation = annotation as? StarAnnotation {
            
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StarAnnotationView.identifier) else { return nil }
            
            annotationView.annotation = starAnnotation
            annotationView.image = UIImage(named: Constants.Image.starAnnotation)
            
            return annotationView
            
        } else if let constellationAnnotation = annotation as? ConstellationAnnotation {
            
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ConstellationAnnotationView.identifier) else { return nil }
            
            annotationView.annotation = constellationAnnotation
            
            // FIXME: 별자리 그리는 메소드를 통해 Constellation Annotation마다 각자의 annotation image를 가지게 해야합니다.
            annotationView.image = UIImage(named: "mock_cluster")
            
            return annotationView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? ConstellationAnnotationView,
              let annotation = view.annotation as? ConstellationAnnotation else { return }
        
        setDismissButton(type: .pop)
        presentStarAnnotations(selectedCourseID: annotation.courseId)
        presentRecordButton()
    }
}

// MARK: - User Interactions
extension LogMapViewController {
    @objc
    private func dismissButtonPressed(_ sender: UIButton) {
        // TODO: dismiss
        viewModel.tapDismissButton()
    }
    
    @objc
    private func popButtonPressed(_ sender: UIButton) {
        setDismissButton(type: .dismiss)
        dismissRecordButton()
        presentConstellationAnnotations()
        presentLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude, span: 0.05)
    }
    
    @objc
    private func recordButtonPressed(_ sender: UIButton) {
        // TODO: record button pressed
    }
}
