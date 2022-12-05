//
//  PlaceSearchResultAnnotationView.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import MapKit
import UIKit

import SnapKit

final class PlaceSearchResultAnnotationView: MKAnnotationView {
    static let identifier = "PlaceSearchResultAnnotationViewIdentifier"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        displayPriority = .required
        centerOffset = CGPoint(x: 0, y: -18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class PlaceSearchResultAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
