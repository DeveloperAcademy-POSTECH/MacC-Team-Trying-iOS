//
//  AddCourseMapViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import CancelBag
import SnapKit

final class AddCourseMapViewController: BaseViewController {
    var type: AddCourseFlowType
    var viewModel: AddCourseMapViewModel
    
    private var recentAnnotation: MKAnnotation?
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
    private lazy var placeMapView: MKMapView = {
        let map = MKMapView()
        map.register(StarAnnotationView.self, forAnnotationViewWithReuseIdentifier: StarAnnotationView.identifier)
        map.delegate = self
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapView(_:)))
        map.addGestureRecognizer(tapGestureRecognizer)
        return map
    }()
    private lazy var placeDetailView: PlaceDetailView = {
        let view = PlaceDetailView()
        view.addCourseButton.addTarget(self, action: #selector(didTapAddCourseButton(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var placeListView: PlaceListView = {
        let view = PlaceListView(parentView: self.view)
        view.mapPlaceTableView.dataSource = self
        view.mapPlaceTableView.delegate = self
        view.mapPlaceTableView.dragInteractionEnabled = true
        view.mapPlaceTableView.dragDelegate = self
        view.mapPlaceTableView.dropDelegate = self
        return view
    }()
    private lazy var nextButton: MainButton = {
        let button = MainButton(type: .empty)
        button.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
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
        
        self.viewModel.$places
            .sink(receiveValue: { [weak self] places in
                guard let self = self else { return }
                let numberOfPlaces = places.count
                self.placeListView.numberOfItems = numberOfPlaces

                self.presentPlaceListView()
                if numberOfPlaces == 0 {
                    if self.placeListView.placeListViewStatus == .full {
                        self.placeListView.placeListViewStatus = .medium
                    }
                    DispatchQueue.main.async {
                        self.nextButton.hide()
                    }
                }

                DispatchQueue.main.async {
                    self.placeListView.mapPlaceTableView.reloadData()
                    self.nextButton.setTitle("\(numberOfPlaces)개 선택 완료", for: .normal)
                }
            })
            .cancel(with: cancelBag)
    }
    
    init(type: AddCourseFlowType, viewModel: AddCourseMapViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocation = locationManager.location
        setUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNofifications()
        
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
        
        removeNotifications()
    }
}

// MARK: - UI
extension AddCourseMapViewController: NavigationBarConfigurable {
    private func setUI() {
        configureRecordMapNavigationBar(target: self, dismissAction: #selector(backButtonPressed(_:)), pushAction: #selector(placeSearchButtonPressed(_:)))
        setLayout()
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(
            placeMapView,
            placeDetailView,
            placeListView,
            nextButton
        )
        
        placeMapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        placeDetailView.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(-placeDetailView.height)
            make.height.equalTo(placeDetailView.height)
        }
        
        placeListView.snp.makeConstraints { make in
            make.leading
                .trailing
                .bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(-58)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddCourseMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.viewModel.changePlaceOrder(sourceIndex: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapPlaceTableViewCell.identifier, for: indexPath) as? MapPlaceTableViewCell else { return UITableViewCell() }
        
        let place = viewModel.places[indexPath.row]
        
        cell.configure(number: indexPath.row + 1, place: place)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
}

// MARK: - UITableViewDrageDelegate, UITableViewDropDelegate
extension AddCourseMapViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}

// MARK: - User Interactions
extension AddCourseMapViewController {
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
        viewModel.pop()
    }
    
    @objc
    private func placeSearchButtonPressed(_ sender: UIButton) {
        placeDetailView.memoTextField.resignFirstResponder()
        viewModel.pushToPlaceSearchView()
    }
    
    @objc
    private func didTapAddCourseButton(_ sender: UIButton) {
        placeDetailView.memoTextField.resignFirstResponder()
        viewModel.addPlace(self.placeDetailView.selectedPlace!)
        viewModel.addAnnotation(recentAnnotation!)
        recentAnnotation = nil
    }
    
    @objc
    private func didTapDeleteButton(_ sender: UIButton) {
        let index = sender.tag
        HapticManager.instance.selection()
        viewModel.deletePlace(index)
        viewModel.deleteAnnotation(map: self.placeMapView, at: index)
    }
    
    @objc
    private func didTapNextButton(_ sender: UIButton) {
        if type == .record {
            viewModel.pushToRecordCourseView()
        } else {
            Task {
                try await viewModel.addCoursePlan()
            }
            viewModel.pushToAddCourseCompleteView()
        }
    }
    
    private func presentPlaceDetailView(with place: CLPlacemark) {
        placeDetailView.selectedPlace = place
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.placeListView.hide()
            self.placeDetailView.present()
            self.nextButton.hide()
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    private func presentPlaceListView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.placeDetailView.hide()
            self.placeListView.present()
            self.nextButton.present()
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                animations: {
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    @objc
    private func didTapMapView(_ sender: UITapGestureRecognizer) {
        placeDetailView.memoTextField.resignFirstResponder()
        viewModel.memo = nil
        let location = sender.location(in: placeMapView)
        let mapPoint = placeMapView.convert(location, toCoordinateFrom: placeMapView)
        
        if sender.state == .ended {
            searchLocation(mapPoint)
        }
    }
    
    private func removeRecentAnnotation() {
        guard let recentAnnotation = recentAnnotation else { return }
        placeMapView.removeAnnotation(recentAnnotation)
    }
    
    private func searchLocation(_ point: CLLocationCoordinate2D) {
        let geocoder: CLGeocoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        removeRecentAnnotation()
        
        geocoder.reverseGeocodeLocation(location) { placeMarks, error in
            if error == nil, let marks = placeMarks {
                marks.forEach { placeMark in
                    let starAnnotation = StarAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: point.latitude,
                            longitude: point.longitude
                        )
                    )
                    
                    self.presentPlaceDetailView(with: placeMark)
                    self.placeMapView.addAnnotation(starAnnotation)
                }
            } else {
                print("검색 실패")
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension AddCourseMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StarAnnotation else { return nil }
        
        recentAnnotation = annotation
        var annotationView = self.placeMapView.dequeueReusableAnnotationView(withIdentifier: StarAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: StarAnnotationView.identifier)
            annotationView?.canShowCallout = true
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: Constants.Image.starAnnotation)
        
        annotationView?.clusteringIdentifier = viewModel.courseTitle
        annotationView?.displayPriority = .defaultHigh
        
        return annotationView
    }
}

// MARK: - CLLocationManagerDelegate
extension AddCourseMapViewController: CLLocationManagerDelegate {
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
