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
    var viewModel: FeedMapViewModel?
    private var mapView = MKMapView()
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews(mapView)

        let location = CLLocationCoordinate2D(latitude: 37.5030042, longitude: 127.0507571)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.title = "HERE!!!!"
        annotation.coordinate = location
        mapView.addAnnotation(annotation)

        mapView.delegate = self
        mapView.snp.makeConstraints { make in
            make.center.width.height.equalToSuperview()
        }
        setUI()
        bind()
    }
}

extension FeedMapViewController: MKMapViewDelegate {

}

// MARK: - UI
extension FeedMapViewController: NavigationBarConfigurable{
    private func setUI() {
        configureMapNavigationBar(target: self, dismissAction: #selector(backButtonPressed(_:)), pushAction: #selector(backButtonPressed(_:)))
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        
    }
}

extension FeedMapViewController {

    @objc
    func backButtonPressed(_ sender: UIButton) {
        print("backButton Pressed")
    }


}

#if DEBUG

import SwiftUI
struct FeedMapViewControllerReperesentable: UIViewControllerRepresentable {

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // empty
    }

    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        FeedMapViewController()
    }
}

@available(iOS 13.0.0, *)
struct FeedMapViewControllerRepresentablePreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            FeedMapViewControllerReperesentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
        }
    }
}
#endif
