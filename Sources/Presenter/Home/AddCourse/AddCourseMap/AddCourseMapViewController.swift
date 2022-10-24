//
//  AddCourseMapViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import MapKit
import UIKit

import CancelBag
import SnapKit

final class AddCourseMapViewController: BaseViewController {
    var viewModel: AddCourseMapViewModel?
    
    private var placeListViewHeight: CGFloat {
        // 기본으로 줘야하는 높이 : 45
        // indicator 영역 높이 : 15
        // main button 높이 : 58
        // 위 3개는 최소 높이. (45 + 15 + 58 = 118)
        // 이후 셀 하나가 추가되는 만큼 셀 높이 추가해주기
        // 셀 하나의 높이 : 67
        switch viewModel?.places.count {
        case 0:
            return 0
        case 1:
            return 185
        case 2:
            return 252
        default:
            return 319
        }
    }
    
    private var recentAnnotation: MKAnnotation?
    private lazy var placeMapView: MKMapView = {
        let map = MKMapView()
        map.register(StarAnnotationView.self, forAnnotationViewWithReuseIdentifier: StarAnnotationView.identifier)
        map.delegate = self
        map.setRegion(
            // TODO: 사용자의 현재 위치 정보를 가져오기
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 36.01436040811483, longitude: 129.32476193278993),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
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
        let view = PlaceListView(parentView: self.view, numberOfItems: (viewModel?.places.count)!)
        view.mapPlaceTableView.dataSource = self
        view.mapPlaceTableView.delegate = self
        return view
    }()
    private lazy var nextButton = MainButton(type: .next)
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        self.viewModel?.$places
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.placeListView.mapPlaceTableView.reloadData()
            })
            .cancel(with: cancelBag)
        
        self.viewModel?.$places
            .sink(receiveValue: { [weak self] places in
                self?.placeListView.numberOfItems = places.count
            })
            .cancel(with: cancelBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UI
extension AddCourseMapViewController: NavigationBarConfigurable {
    private func setUI() {
        configureMapNavigationBar(target: self, dismissAction: #selector(backButtonPressed(_:)), pushAction: #selector(nextButtonPressed(_:)))
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        
        view.addSubviews(placeMapView, placeDetailView, placeListView, nextButton)
        
        placeMapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        placeDetailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        placeListView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            
            make.height.equalTo(placeListViewHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            if placeListViewHeight == 0 {
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalTo(view.snp.bottom)
            } else {
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddCourseMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapPlaceTableViewCell.identifier, for: indexPath) as? MapPlaceTableViewCell else { return UITableViewCell() }
        
        let place = viewModel?.places[indexPath.row]
        
        cell.numberLabel.text = String(indexPath.row + 1)
        cell.titleLabel.text = place?.title
        cell.categoryLabel.text = place?.category
        cell.addressLabel.text = place?.address
        cell.deleteButton.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        67
    }
}

// MARK: - User Interactions
extension AddCourseMapViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        viewModel?.pop()
    }
    
    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        print("next")
    }
    
    @objc
    private func didTapAddCourseButton(_ sender: UIButton) {
        presentPlaceListView()
        viewModel?.addPlace(self.placeDetailView.selectedPlace!, annotation: recentAnnotation!)
        recentAnnotation = nil
    }
    
    @objc
    private func didTapDeleteButton(_ sender: UIButton) {
        let annotation = (viewModel?.places[sender.tag].annotation)!
        placeMapView.removeAnnotation(annotation)
        viewModel?.deletePlace(sender.tag)
        
        if (viewModel?.places.count)! < 3 {
            presentPlaceListView()
        }
    }
    
    private func presentPlaceDetailView(with place: CLPlacemark) {
        placeDetailView.selectedPlace = place
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.placeListView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            self.nextButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalTo(self.view.snp.bottom)
            }
            
            self.placeDetailView.snp.updateConstraints { make in
                make.height.equalTo(264)
            }
            
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
            self.placeDetailView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            self.nextButton.snp.remakeConstraints { make in
                if self.placeListViewHeight == 0 {
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.top.equalTo(self.view.snp.bottom)
                } else {
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                    make.height.equalTo(58)
                }
            }
            
            if self.placeListView.isContainerCollapsed {
                self.placeListView.snp.updateConstraints { make in
                    make.height.equalTo(self.placeListViewHeight)
                }
            } else {
                if self.placeListViewHeight == 0 {
                    self.placeListView.snp.remakeConstraints { make in
                        make.height.equalTo(0)
                        make.leading.trailing.bottom.equalToSuperview()
                    }
                    self.placeListView.isContainerCollapsed.toggle()
                }
            }
            
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
                    let starAnnotation = StarAnnotation(coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
                    
                    self.presentPlaceDetailView(with: placeMark)
                    self.placeMapView.addAnnotation(starAnnotation)
                }
            } else {
                print("검색 실패")
            }
        }
    }
}

// MARK: - MKMapViewDelegate, CLLocationManagerDelegate
extension AddCourseMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
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
        
        return annotationView
    }
}

// MARK: - Helper Methods
extension AddCourseMapViewController {
    
}
