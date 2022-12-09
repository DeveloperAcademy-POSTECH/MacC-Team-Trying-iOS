//
//  PlaceSearchResultMapViewController.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import CancelBag
import SnapKit

protocol AddPlaceDelegate: AnyObject {
    func addPlace(place: Place)
}

final class PlaceSearchResultMapViewController: BaseViewController {
    private var viewModel: PlaceSearchResultMapViewModel
    weak var delegate: AddPlaceDelegate?
    private let searchText: String
    private let searchedPlaces: [Place]
    private var selectedPlace: Place?
    private var recentAnnotation: MKAnnotation?
    private let presentLocation: CLLocationCoordinate2D
    
    private lazy var placeDetailView: AddPlaceDetailView = {
        let view = AddPlaceDetailView()
        view.memoTextField.addTarget(self, action: #selector(dismissKeyboard(_:)), for: .editingDidEndOnExit)
        view.addCourseButton.addTarget(self, action: #selector(addCourseButtonPressed(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.register(StarAnnotationView.self, forAnnotationViewWithReuseIdentifier: StarAnnotationView.identifier)
        map.register(PlaceSearchResultAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceSearchResultAnnotationView.identifier)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapViewPressed(_:)))
        map.addGestureRecognizer(tapGestureRecognizer)
        map.delegate = self
        map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: LocationManager.shared.latitude,
                    longitude: LocationManager.shared.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
        map.showsUserLocation = true
        map.setUserTrackingMode(.followWithHeading, animated: true)
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
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        self.placeDetailView.memoTextField.optionalTextPublisher()
            .assign(to: &viewModel.$memo)
        
        // output
        self.viewModel.$memo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] memo in
                guard let self = self else { return }
                self.placeDetailView.memoTextField.text = memo
            }
            .cancel(with: cancelBag)
    }
    
    init(searchText: String, searchedPlaces: [Place], presentLocation: CLLocationCoordinate2D, viewModel: PlaceSearchResultMapViewModel) {
        self.searchText = searchText
        self.searchedPlaces = searchedPlaces
        self.presentLocation = presentLocation
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setNofifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotifications()
    }
}

// MARK: - UI
extension PlaceSearchResultMapViewController: NavigationBarConfigurable {
    private func setUI() {
        configurePlaceSearchResultMapNavigationBar(target: self, searchText: searchText, popAction: #selector(backButtonPressed(_:)), dismissAction: #selector(dismissButtonPressed(_:)))
        self.presentLocation(latitude: presentLocation.latitude, longitude: presentLocation.longitude, span: 0.05)
        self.presentSearchedPlaces(places: searchedPlaces)
        
        if self.searchedPlaces.count == 1 {
            self.selectedPlace = searchedPlaces[0]
            self.addStarAnnotation(place: selectedPlace!)
            self.presentPlaceDetailView(with: selectedPlace!)
        }
        
        self.setLayout()
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        mapView.addSubview(userTrackingButton)
        
        view.addSubviews(
            mapView,
            placeDetailView
        )
        
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        userTrackingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
        placeDetailView.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(-placeDetailView.height)
            make.height.equalTo(placeDetailView.height)
        }
    }
    
    func presentSearchedPlaces(places: [Place]) {
        let averageLatitude = places.reduce(into: 0.0) { $0 += $1.location.latitude } / Double(places.count)
        let averageLongitude = places.reduce(into: 0.0) { $0 += $1.location.longitude } / Double(places.count)
        
        places.forEach { place in
            self.addPlaceSearchResultAnnotation(latitude: place.location.latitude, longitude: place.location.longitude)
        }
        
        self.presentLocation(latitude: averageLatitude, longitude: averageLongitude, span: 0.05)
    }
    
    private func addPlaceSearchResultAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let placeSearchResultAnnotation = PlaceSearchResultAnnotation(
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
        )
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(placeSearchResultAnnotation)
        }
    }
    
    private func addStarAnnotation(place: Place) {
        let starAnnotation = StarAnnotation(
            coordinate: CLLocationCoordinate2D(
                latitude: place.location.latitude,
                longitude: place.location.longitude
            ),
            placeId: place.id
        )
        
        self.recentAnnotation = starAnnotation
        DispatchQueue.main.async {
            self.mapView.addAnnotation(starAnnotation)
        }
    }
    
    /*
    private func addStarAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let starAnnotation = StarAnnotation(
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            placeId: <#T##Int#>
        )
        
        self.recentAnnotation = starAnnotation
        DispatchQueue.main.async {
            self.mapView.addAnnotation(starAnnotation)
        }
    }
     */
    
    private func removeRecentAnnotation() {
        guard let recentAnnotation = recentAnnotation else { return }
        DispatchQueue.main.async {
            self.mapView.removeAnnotation(recentAnnotation)
        }
        self.recentAnnotation = nil
    }
    
    private func presentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, span: Double) {
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: spanValue), animated: true)
    }
    
    private func presentPlaceDetailView(with place: Place) {
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
}

// MARK: - MKMapViewDelegate
extension PlaceSearchResultMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let starAnnotation = annotation as? StarAnnotation {
            
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StarAnnotationView.identifier) else { return nil }
            
            annotationView.annotation = starAnnotation
            annotationView.centerOffset = CGPoint(x: 0, y: -45)
            annotationView.image = UIImage(named: Constants.Image.starAnnotation)
            
            return annotationView
            
        } else if let placeResultAnnotation = annotation as? PlaceSearchResultAnnotation {
            
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PlaceSearchResultAnnotationView.identifier) else { return nil }
            
            annotationView.annotation = placeResultAnnotation
            annotationView.image = UIImage(named: Constants.Image.placeResultAnnotation)
            
            return annotationView
            
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? PlaceSearchResultAnnotationView,
        let selectedAnnotation = annotationView.annotation as? PlaceSearchResultAnnotation else { return }
        
        HapticManager.instance.selection()
        
        self.viewModel.memo = nil
        self.removeRecentAnnotation()
        
        self.searchedPlaces.forEach { place in
            if selectedAnnotation.coordinate.latitude == place.location.latitude &&
                selectedAnnotation.coordinate.longitude == place.location.longitude {
                self.selectedPlace = place
            }
        }
        
        guard let selectedPlace = selectedPlace else { return }
        self.addStarAnnotation(place: selectedPlace)
        self.presentPlaceDetailView(with: selectedPlace)
    }
}

// MARK: - User Interactions
extension PlaceSearchResultMapViewController {
    private func setNofifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        self.placeDetailView.snp.updateConstraints { make in
                            make.bottom.equalToSuperview().inset(keyboardHeight - 8)
                        }
                        self.view.layoutIfNeeded()
                    }
                )
            }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(
                withDuration: 0.27,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.placeDetailView.snp.updateConstraints { make in
                        make.bottom.equalToSuperview()
                    }
                    self.view.layoutIfNeeded()
                }
            )
        }
    }

    private func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        self.viewModel.pop()
    }
    
    @objc
    private func dismissButtonPressed(_ sender: UIButton) {
        self.viewModel.dismiss()
    }
    
    @objc
    private func dismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @objc
    private func addCourseButtonPressed(_ sender: UIButton) {
        self.placeDetailView.memoTextField.resignFirstResponder()
        self.viewModel.dismiss()
        
        guard var selectedPlace = selectedPlace else { return }
        selectedPlace.memo = self.viewModel.memo
        delegate?.addPlace(place: selectedPlace)
    }
    
    @objc
    private func mapViewPressed(_ sender: UITapGestureRecognizer) {
        self.placeDetailView.memoTextField.resignFirstResponder()
    }
}
