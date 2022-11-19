//
//  LocationManager.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

final class LocationManager: CLLocationManager {
    static let shared = LocationManager()
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    override private init() {
        super.init()
        self.delegate = self
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = .infinity
        self.startUpdatingHeading()
        self.startUpdatingLocation()
        self.startMonitoringSignificantLocationChanges()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        self.setLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            guard let location = manager.location else { return }
            self.setLocation(location)
        case .restricted :
            break
        case .denied :
            break
        default:
            break
        }
    }
    
    private func setLocation(_ location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
