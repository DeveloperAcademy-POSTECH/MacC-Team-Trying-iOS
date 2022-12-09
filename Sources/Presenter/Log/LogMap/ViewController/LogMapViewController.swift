//
//  LogMapViewController.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation
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
    
    private lazy var reviewButton: ReviewButton = {
        let button = ReviewButton()
        button.addTarget(self, action: #selector(presentTicketView), for: .touchUpInside)
        return button
    }()
    
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
    
    private func presentPlacesOnMap(courseId: Int) {
        self.viewModel.getCourseIndex(courseId: courseId)
        self.toggleDismissButton()
        self.presentStarAnnotations(selectedCourseID: courseId)
        self.presentReviewButton()
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
            annotationView.image = self.makeConstellationAnnotationViewImage(courseID: constellationAnnotation.courseId)
            
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
            
            self.presentPlacesOnMap(courseId: constellationAnnotation.courseId)
            
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
    private func mapViewPressed(_ sender: UITapGestureRecognizer) {
        self.hidePlaceDetailView()
    }
}

// MARK: - Helper
extension LogMapViewController {
    private func toggleDismissButton() {
        DispatchQueue.main.async {
            self.dismissButton.isHidden.toggle()
            self.popButton.isHidden.toggle()
        }
    }
    
    private func makeConstellationAnnotationViewImage(courseID: Int) -> UIImage {
        guard let course = viewModel.courses.first(where: { $0.id == courseID }) else { return UIImage() }
        guard let constellationImage = StarMaker.makeStars(places: course.places)?.resizeImageTo(size: CGSize(width: 15, height: 15)) else { return UIImage() }
    
        let font = UIFont.systemFont(ofSize: 11)
        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = CGRect(x: 0, y: (font.capHeight - constellationImage.size.height).rounded() / 2, width: constellationImage.size.width, height: constellationImage.size.height)
        imageAttachment.image = constellationImage
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let courseTitleString = NSAttributedString(
            string: course.courseTitle,
            attributes: [
                .foregroundColor: UIColor.designSystem(.white) as Any,
                .font: UIFont.designSystem(weight: .bold, size: ._11)
            ]
        )
        
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(courseTitleString)
        
        let customAnnotationView = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10))
        customAnnotationView.numberOfLines = 1
        
        customAnnotationView.attributedText = attributedString
        
        customAnnotationView.backgroundColor = .designSystem(.black)
        customAnnotationView.layer.cornerRadius = 15
        customAnnotationView.layer.masksToBounds = true
        
        customAnnotationView.frame.size = customAnnotationView.intrinsicContentSize
        customAnnotationView.frame.size.height = 30
        
        return customAnnotationView.asImage()
    }
    
    @objc
    func presentTicketView() {
        guard let selectedCourseIndex = viewModel.selectedCourseIndex else { return }
        viewModel.presentTicketView(course: viewModel.courses[selectedCourseIndex], selectedCourseIndex: selectedCourseIndex)
    }
}
