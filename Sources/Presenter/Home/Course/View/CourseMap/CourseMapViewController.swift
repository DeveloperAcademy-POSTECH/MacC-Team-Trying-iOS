//
//  CourseMapViewController.swift
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

final class CourseMapViewController: BaseViewController {
    var viewModel: CourseMapViewModel
    
    // private var recentAnnotations = [MKAnnotation]()
    private var selectedAnnotations = [MKAnnotation]()
    private let locationManager = LocationManager.shared
    
    private lazy var placeMapView: MKMapView = {
        let map = MKMapView()
        map.register(StarAnnotationView.self, forAnnotationViewWithReuseIdentifier: StarAnnotationView.identifier)
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
        map.setUserTrackingMode(.followWithHeading, animated: true)
        map.showsCompass = false
        // let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapView(_:)))
        // map.addGestureRecognizer(tapGestureRecognizer)
        return map
    }()
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton()
        button.mapView = placeMapView
        button.backgroundColor = .designSystem(.gray252632)
        button.tintColor = .designSystem(.mainYellow)
        button.layer.cornerRadius = 5
        return button
    }()
    /*
    private lazy var placeDetailView: PlaceDetailView = {
        let view = PlaceDetailView()
        view.memoTextField.addTarget(self, action: #selector(dismissKeyboard(_:)), for: .editingDidEndOnExit)
        view.addCourseButton.addTarget(self, action: #selector(didTapAddCourseButton(_:)), for: .touchUpInside)
        return view
    }()
    */
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
        /*
        self.placeDetailView.memoTextField.optionalTextPublisher()
            .assign(to: &viewModel.$memo)
        */
        
        // output
        /*
        self.viewModel.$memo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] memo in
                guard let self = self else { return }
                self.placeDetailView.memoTextField.text = memo
            }
            .cancel(with: cancelBag)
        */
        
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
                    // MARK: reload가 조금 느리게 되는 이슈가 있습니다.
                    self.placeListView.mapPlaceTableView.reloadData()
                    self.nextButton.setTitle("\(numberOfPlaces)개 선택 완료", for: .normal)
                }
            })
            .cancel(with: cancelBag)
    }
    
    init(viewModel: CourseMapViewModel) {
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
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNofifications()
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // self.removeNotifications()
        
        // self.removeRecentAnnotations()
        DispatchQueue.main.async {
            // self.placeDetailView.hide()
            self.placeListView.hide()
            self.nextButton.hide()
        }
    }
}

// MARK: - UI
extension CourseMapViewController: NavigationBarConfigurable {
    private func setUI() {
        configureRecordMapNavigationBar(target: self, dismissAction: #selector(backButtonPressed(_:)), pushAction: #selector(placeSearchButtonPressed(_:)))
        setLayout()
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        placeMapView.addSubview(userTrackingButton)
        
        view.addSubviews(
            placeMapView,
            // placeDetailView,
            placeListView,
            nextButton
        )
        
        placeMapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        userTrackingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
        /*
        placeDetailView.snp.makeConstraints { make in
            make.leading
                .trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(-placeDetailView.height)
            make.height.equalTo(placeDetailView.height)
        }
        */
        
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
extension CourseMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.viewModel.changePlaceOrder(sourceIndex: sourceIndexPath.row, to: destinationIndexPath.row)
        self.changeAnnotationOrder(sourceIndex: sourceIndexPath.row, to: destinationIndexPath.row)
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
extension CourseMapViewController: UITableViewDragDelegate, UITableViewDropDelegate {
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
extension CourseMapViewController {
    /*
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
    */

    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel.pop()
    }
    
    @objc
    private func placeSearchButtonPressed(_ sender: UIButton) {
        // placeDetailView.memoTextField.resignFirstResponder()
        viewModel.pushToPlaceSearchView()
    }
    
    @objc
    private func dismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /*
    @objc
    private func didTapAddCourseButton(_ sender: UIButton) {
        /*
        placeDetailView.memoTextField.resignFirstResponder()
        viewModel.addPlace(self.placeDetailView.selectedPlace!)
         */
        self.selectedAnnotations.append(recentAnnotations.first!)
        recentAnnotations.removeAll()
    }
     */
    
    @objc
    private func didTapDeleteButton(_ sender: UIButton) {
        let index = sender.tag
        HapticManager.instance.selection()
        viewModel.deletePlace(index)
        let removedAnnotation = self.selectedAnnotations.remove(at: index)
        self.placeMapView.removeAnnotation(removedAnnotation)
    }
    
    @objc
    private func didTapNextButton(_ sender: UIButton) {
        self.viewModel.pushToNextView()
    }

    private func presentPlaceDetailView(with place: Place) {
        // placeDetailView.selectedPlace = place
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.placeListView.hide()
            // self.placeDetailView.present()
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
            // self.placeDetailView.hide()
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
    
    /*
    @objc
    private func didTapMapView(_ sender: UITapGestureRecognizer) {
        placeDetailView.memoTextField.resignFirstResponder()
        viewModel.memo = nil
        let location = sender.location(in: placeMapView)
        let mapPoint = placeMapView.convert(location, toCoordinateFrom: placeMapView)
        
        if sender.state == .ended {
            self.removeRecentAnnotations()
            Task {
                self.placeMapView.isUserInteractionEnabled = false
                let place = try await self.viewModel.searchPlace(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
                
                if let place = place {
                    self.addStarAnnotation(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
                    self.presentPlaceDetailView(with: place)
                } else {
                    DispatchQueue.main.async {
                        self.placeDetailView.hide()
                        self.placeListView.hide()
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
                self.placeMapView.isUserInteractionEnabled = true
            }
        }
    }
    */
    
    private func addStarAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let starAnnotation = StarAnnotation(
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
        )
        // self.recentAnnotations.append(starAnnotation)
        self.selectedAnnotations.append(starAnnotation)
        DispatchQueue.main.async {
            self.placeMapView.addAnnotation(starAnnotation)
        }
    }
    
    /*
    private func removeRecentAnnotations() {
        self.placeMapView.removeAnnotations(self.recentAnnotations)
        self.recentAnnotations.removeAll()
    }
     */
    
    private func changeAnnotationOrder(sourceIndex: Int, to destinationIndex: Int) {
        let targetAnnotation = selectedAnnotations[sourceIndex]
        self.selectedAnnotations.remove(at: sourceIndex)
        self.selectedAnnotations.insert(targetAnnotation, at: destinationIndex)
    }
}

// MARK: - MKMapViewDelegate
extension CourseMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StarAnnotation else { return nil }
        
        var annotationView = self.placeMapView.dequeueReusableAnnotationView(withIdentifier: StarAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: StarAnnotationView.identifier)
            annotationView?.canShowCallout = true
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: Constants.Image.starAnnotation)
        
        return annotationView
    }
    
    /*
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? StarAnnotationView,
        let selectedAnnotation = annotationView.annotation as? StarAnnotation else { return }
        
        if self.recentAnnotations.contains(where: { annotation -> Bool in
            return annotation === selectedAnnotation
        }) {
            
        } else {
            
        }
    }
     */
}

// MARK: - AddPlaceDelegate
extension CourseMapViewController: AddPlaceDelegate {
    func addPlace(place: Place) {
        self.viewModel.addPlace(place)
        self.addStarAnnotation(latitude: place.location.latitude, longitude: place.location.longitude)
    }
}

/*
// MARK: - PlacePresenting
extension CourseMapViewController: PlacePresenting {
    func presentSelectedPlace(place: Place) {
        self.addStarAnnotation(latitude: place.location.latitude, longitude: place.location.longitude)
        self.presentLocation(latitude: place.location.latitude, longitude: place.location.longitude, span: 0.01)
        self.presentPlaceDetailView(with: place)
    }
    
    func presentSearchedPlaces(places: [Place]) {
        let averageLatitude = places.reduce(into: 0.0) { $0 += $1.location.latitude } / Double(places.count)
        let averageLongitude = places.reduce(into: 0.0) { $0 += $1.location.longitude } / Double(places.count)
        
        self.removeRecentAnnotations()
        DispatchQueue.main.async {
            self.placeDetailView.hide()
            self.placeListView.hide()
            self.nextButton.hide()
        }
        
        places.forEach { place in
            self.addStarAnnotation(latitude: place.location.latitude, longitude: place.location.longitude)
        }
        
        self.presentLocation(latitude: averageLatitude, longitude: averageLongitude, span: 0.05)
    }
    
    private func presentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, span: Double) {
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        
        placeMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: spanValue), animated: true)
    }
}
*/
