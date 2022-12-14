//
//  ConstellationAnnotationView.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/08.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import MapKit

final class ConstellationAnnotationView: MKAnnotationView {
    static let identifier = "ConstellationAnnotationViewIdentifier"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        displayPriority = .required
        centerOffset = CGPoint(x: 0, y: -18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ConstellationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    var courseId: Int
    
    init(
        coordinate: CLLocationCoordinate2D,
        courseId: Int
    ) {
        self.coordinate = coordinate
        self.courseId = courseId
    }
}
