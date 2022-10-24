//
//  StarAnnotationView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/24.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import MapKit
import UIKit

import SnapKit

final class StarAnnotationView: MKAnnotationView {
    static let identifier = "StarAnnotationViewIdentifier"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        centerOffset = CGPoint(x: 0, y: -18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class StarAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
