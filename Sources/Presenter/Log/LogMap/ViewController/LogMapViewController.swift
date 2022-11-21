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
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.Image.navBarDeleteButton), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var popButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.Image.navBarPopButton), for: .normal)
        button.addTarget(self, action: #selector(popButtonPressed(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapViewPressed(_:)))
        map.addGestureRecognizer(tapGestureRecognizer)
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
    
    private let reviewButton = ReviewButton()
    
    private let placeDetailView = PlaceInformationView()
    
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
        setLayout()
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        mapView.addSubview(userTrackingButton)
        
        view.addSubviews(
            mapView,
            dismissButton,
            popButton,
            reviewButton,
            placeDetailView
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
        
        popButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(-reviewButton.height)
            make.width.equalTo(110)
            make.height.equalTo(reviewButton.height)
        }
        
        placeDetailView.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(-placeDetailView.height)
            make.height.equalTo(placeDetailView.height)
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
    
    private func presentReviewButton() {
        DispatchQueue.main.async {
            self.reviewButton.present()
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    private func dismissReviewButton() {
        DispatchQueue.main.async {
            self.reviewButton.hide()
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    private func presentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, span: Double) {
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: spanValue), animated: true)
    }
    
    private func toggleDismissButton() {
        self.dismissButton.isHidden.toggle()
        self.popButton.isHidden.toggle()
    }
    
    private func presentPlaceDetailView(with place: PlaceEntity) {
        self.placeDetailView.selectedPlace = place
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.placeDetailView.present()
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    private func hidePlaceDetailView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.placeDetailView.hide()
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
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
        if let starAnnotation = view.annotation as? StarAnnotation {
            
            guard let place = viewModel.places.first(where: { $0.id == starAnnotation.placeId }) else { return }
            self.presentPlaceDetailView(with: place)
            
        } else if let constellationAnnotation = view.annotation as? ConstellationAnnotation {
            
            self.toggleDismissButton()
            self.presentStarAnnotations(selectedCourseID: constellationAnnotation.courseId)
            self.presentReviewButton()
            
        } else {
            return
        }
    }
}

// MARK: - User Interactions
extension LogMapViewController {
    @objc
    private func dismissButtonPressed(_ sender: UIButton) {
        self.viewModel.dismissButtonPressed()
    }
    
    @objc
    private func popButtonPressed(_ sender: UIButton) {
        self.hidePlaceDetailView()
        self.toggleDismissButton()
        self.dismissReviewButton()
        self.presentConstellationAnnotations()
        presentLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude, span: 0.05)
    }
    
    @objc
    private func recordButtonPressed(_ sender: UIButton) {
        // TODO: record button pressed
    }
    
    @objc
    private func mapViewPressed(_ sender: UITapGestureRecognizer) {
        self.hidePlaceDetailView()
    }
}
